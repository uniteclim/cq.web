# تثبيت CQ Web V2

## 1) Supabase

افتح مشروع Supabase ثم:

`SQL Editor → New query`

نفّذ الملفات بهذا الترتيب:

1. `supabase/schema.sql`
2. `supabase/schema-auth.sql`
3. `supabase/schema-v2.sql`

ثم افتح **Database → Publications** وتأكد أن Realtime مفعّل للجداول المطلوبة، خصوصًا `cq_notifications` و`quality_problems` و`quality_problem_actions` إذا كانت موجودة في `schema-v2.sql`.

## 2) إعداد الاتصال

بيانات الاتصال موجودة بوضوح في:

`config/supabase-config.js`

يحتوي الملف على:
- Supabase URL
- Publishable/Anon key

لا تضع Service Role/Secret Key في هذا الملف.

## 3) GitHub

ارفع كامل محتويات مجلد `CQ-Web-V2` إلى مستودع GitHub.

ثم:
`Settings → Pages → Deploy from branch → main → /(root)`

## 4) اختبار الاتصال

افتح التطبيق من GitHub Pages، ثم سجل الدخول بالطريقة الحالية للتطبيق. عند نجاح الاتصال، ستتم مزامنة الحالة المشتركة مع Supabase، وتعمل قناة الإشعارات Realtime عندما تكون الجداول والسياسات مفعلة.

## 5) ملاحظة أمنية

هذه النسخة تستخدم مفتاح المتصفح Publishable/Anon فقط. لا تستخدم Service Role Key في HTML أو JavaScript.

نظام الدخول الموجود في التطبيق هو نظام التطبيق الحالي؛ نقل الحسابات بالكامل إلى Supabase Auth مع RLS حسب الدور هو ترقية مستقلة إذا أردت مصادقة قاعدة بيانات كاملة.
