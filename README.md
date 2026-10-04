# CQ Web V2 — Supabase Full Project

نسخة V2 من نظام التحكم في الجودة والإنتاج، جاهزة للرفع إلى GitHub وربطها بمشروع Supabase.

## أهم الملفات

- `index.html` — التطبيق الرئيسي.
- `config/supabase-config.js` — **هنا يوجد ربط Supabase بوضوح**.
- `supabase/schema.sql` — الحالة المشتركة والإشعارات.
- `supabase/schema-auth.sql` — جداول/سياسات المصادقة الموجودة في المشروع.
- `supabase/schema-v2.sql` — وظائف V2 والجداول الإضافية.
- `v2-features.js` — مؤشرات ومزامنة ميزات V2.

## التشغيل

1. نفّذ ملفات SQL في Supabase بالترتيب المذكور في `docs/INSTALL.md`.
2. ارفع كل محتويات المشروع إلى GitHub.
3. فعّل GitHub Pages.
4. افتح رابط التطبيق.

## الربط

الملف:

`config/supabase-config.js`

يحتوي على URL ومفتاح المتصفح لمشروع Supabase.

## الأمان

مفتاح المتصفح Publishable/Anon يمكن استخدامه في تطبيق Frontend. **لا تضع Service Role Key** داخل المشروع.
