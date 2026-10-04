/* CQ Web V2 service layer: quality intelligence, live problems, audit and KPI queries. */
window.CQ_V2={
 enabled:true,
 async kpis(){
  if(!window.CQ_CLOUD?.client) return null;
  const [{data:problems},{data:actions}]=await Promise.all([
   CQ_CLOUD.client.from('quality_problems').select('status,severity,created_at,closed_at'),
   CQ_CLOUD.client.from('quality_problem_actions').select('status,due_date,completed_at')
  ]);
  const p=problems||[], a=actions||[];
  return {totalProblems:p.length,openProblems:p.filter(x=>x.status!=='closed').length,critical:p.filter(x=>x.severity==='critical').length,closureRate:p.length?Math.round(p.filter(x=>x.status==='closed').length*1000/p.length)/10:100,openActions:a.filter(x=>x.status!=='closed').length,overdueActions:a.filter(x=>x.status!=='closed'&&x.due_date&&new Date(x.due_date)<new Date()).length};
 },
 async subscribe(onChange){
  if(!window.CQ_CLOUD?.client) return null;
  return CQ_CLOUD.client.channel('cq-v2-live').on('postgres_changes',{event:'*',schema:'public',table:'quality_problems'},p=>onChange&&onChange(p)).on('postgres_changes',{event:'*',schema:'public',table:'quality_problem_actions'},p=>onChange&&onChange(p)).subscribe();
 }
};
