Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC635136672
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042587; cv=none; b=ECs4vxKzyxvmpmFv2j/nwZWr9YNWhtyKyUfazlcK17FjZP6nvec5LuWYQ7zX+MGoWDLlbcKB1R9nSmvAUHoAUq8SChZNQ6H4ljBz6bfEc+8CQx3PGzuhBBlA9RmgfZeJfk37QbuXb+pjDsgfpCj+BVJ1Yn2XULhIewcmBF6yn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042587; c=relaxed/simple;
	bh=IvzxIBvUwzHcm4/v4OGWrzU1DKw5fC8H6B4Bj5IVlQ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnUcfMOCZwUAnOoQ14rT3ZeQmpEOedIdKcZJndtdpiaJfzlzA+wugHP7jJjvatzbs9+DmaFzg4F4vvV+3PsyanJm7Z/5pj62NJLIMIfdHHlxyyF2pSrHKuTmCLmdK9MgDmEeaHAP9joC1CxCdssQnECZ3FvxRA+ruKCd1RO5w4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I3rKRhP0; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I3rKRhP0"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b735ce67d1dso40862966b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 06:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763042583; x=1763647383; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wu3W5TF6ZWMUfXm+5W1t14GWx2Iu0lhseebcUcOYC60=;
        b=I3rKRhP0UyxekY5mzz6ZvzpaycI+ay2X0dC9HNYkC8vU013ItoVByS9EUlBUx5IHe0
         WWKnHn78hEdwKfC8yBTA46JHfk5R7y0tNPMNWU35I5ExDXA2iaFYWT/82DFlhvZOQ6AP
         wI6HJ4lc9zNogrXu+J0Z5JNug9vOAx2Oy0uo47yMV4dq2594PaK3UN9c9psR4EW8J5B8
         D3MvgmzkY7pTogXuF3cmgt3mtFNTASdDpMdddc6jOW/UcaVY4LO1fwKEIBNioeuwIplw
         tTsXcya7uydMRZsGvcfkEK7RRfxPvZNM/cDFSFTM3pJxcjMT+w7hK/6AhjaverU1BNs3
         ynzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763042583; x=1763647383;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wu3W5TF6ZWMUfXm+5W1t14GWx2Iu0lhseebcUcOYC60=;
        b=f3PXkpwbiQQCm5sm4JKH6R8HRWv3tJwF1c3boGM1JDa5PRhYuNvqReLMMgQTJC+7Ho
         Kj55NNJPLeF50eqKHryqkbEPyEtq7f+Zh6SoXzusC9hzF74VP3F1K+u0BtjZ4Q00Nt3n
         lWMRcYw83ea7KvAvRrmDqRYrtaK7iFCIwadGLH0FgcJoIWhB06WQkpLTILQ/qEpEr4m4
         gWE7rbAdyHa10yp7xPCMDKEj1zzbc3Sh9ADVeZgkxO1FVnKZEe76PIHfynMMJmsf2wXg
         jF8iOemxybCVaPDqGomafhZgTNCKHq+p/ceuyq5R8DfCR8/FxXXhpwdA5DakS2ogUeTx
         goYg==
X-Forwarded-Encrypted: i=1; AJvYcCVVXcTa4ZD6W3hdpmSgY5nWVbtXMU2LX6AMo3X+G7kyDw9s425K5vRqwabT6Zmte4flH//q660HLaNA8IUv@vger.kernel.org
X-Gm-Message-State: AOJu0YzvOqJehtyCLMeWVorKdJ9KtGPlUnlI/OtG2TghyBpFAKKVcCXm
	Tt9e9eiSfufL6859BdGfEYBCPuuGknfXHy1uXBn1+mNsJ+2ryj0UCayRYRkA7WvzjbSiM/4DzAI
	0Y9NwX7tgxDycEXNIK/F3uk7LQJUkcGQ=
X-Gm-Gg: ASbGncuDhxDnTPeBN0aodGBQQkL4HSMUs+hQdckJOyFrQi7leQG+KlalUy8V2vPidFu
	3wIHSQn7EVipVStRUQSayNSrAaDRQImEnkEjdVYJBfLDlKky4gG4334gC7rnIn/x8dssZB0NMjf
	VQwWnueEIMrxroQi81OP2d29lgEBCpvrUlsEg78up8UpyJtLt7fw5Rs23g8aGx0WYUP32EEPmZT
	kCYqNal50i7GTfhasbCuNjSxlrDHs+0p2EVRQMVSxyIxOu5AfUJSEv6oALHxxNQtdMBofGu4Nq7
	DzwDOMBNg5+Yscw5cTcsLeIdhR3Geg==
X-Google-Smtp-Source: AGHT+IGYruc5g07OMfpa1HoGykxgZTsGgq8WuxLHj9Vi5wTJ++9Zw7jQy8rejpyYz47j4lNRCCmKbLAkOPjs9eHBmjo=
X-Received: by 2002:a17:906:ef0c:b0:b73:4b22:19c5 with SMTP id
 a640c23a62f3a-b734b222b7fmr259496866b.44.1763042582648; Thu, 13 Nov 2025
 06:03:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org> <20251113-work-ovl-cred-guard-v1-26-fa9887f17061@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v1-26-fa9887f17061@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 15:02:49 +0100
X-Gm-Features: AWmQ_blMwQlX0Cj-nlzq6RMnEVVxtMIHgW2cUgmfFj4QAK79aNuT2vuHKuQzUtg
Message-ID: <CAOQ4uxi3_sVyMA1vqOUDAw-0SSkVisKYp6c3F3Pn0kej=KsWPA@mail.gmail.com>
Subject: Re: [PATCH RFC 26/42] ovl: port ovl_iterate() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000dd3cfb06437a56d2"

--000000000000dd3cfb06437a56d2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:03=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Use the scoped ovl cred guard.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Please consider this refactoring to help with applying the scope

Thanks,
Amir.

> ---
>  fs/overlayfs/readdir.c | 83 +++++++++++++++++++++++---------------------=
------
>  1 file changed, 38 insertions(+), 45 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index ba345ceb4559..389f83aca57b 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -841,62 +841,55 @@ static int ovl_iterate(struct file *file, struct di=
r_context *ctx)
>         struct dentry *dentry =3D file->f_path.dentry;
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct ovl_cache_entry *p;
> -       const struct cred *old_cred;
>         int err;
>
> -       old_cred =3D ovl_override_creds(dentry->d_sb);
> -       if (!ctx->pos)
> -               ovl_dir_reset(file);
> +       with_ovl_creds(dentry->d_sb) {
> +               if (!ctx->pos)
> +                       ovl_dir_reset(file);
>
> -       if (od->is_real) {
> -               /*
> -                * If parent is merge, then need to adjust d_ino for '..'=
, if
> -                * dir is impure then need to adjust d_ino for copied up
> -                * entries.
> -                */
> -               if (ovl_xino_bits(ofs) ||
> -                   (ovl_same_fs(ofs) &&
> -                    (ovl_is_impure_dir(file) ||
> -                     OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) =
{
> -                       err =3D ovl_iterate_real(file, ctx);
> -               } else {
> -                       err =3D iterate_dir(od->realfile, ctx);
> +               if (od->is_real) {
> +                       /*
> +                        * If parent is merge, then need to adjust d_ino =
for '..', if
> +                        * dir is impure then need to adjust d_ino for co=
pied up
> +                        * entries.
> +                        */
> +                       if (ovl_xino_bits(ofs) || (ovl_same_fs(ofs) &&
> +                           (ovl_is_impure_dir(file) || OVL_TYPE_MERGE(ov=
l_path_type(dentry->d_parent)))))
> +                               return ovl_iterate_real(file, ctx);
> +
> +                       return iterate_dir(od->realfile, ctx);
>                 }
> -               goto out;
> -       }
>
> -       if (!od->cache) {
> -               struct ovl_dir_cache *cache;
> +               if (!od->cache) {
> +                       struct ovl_dir_cache *cache;
>
> -               cache =3D ovl_cache_get(dentry);
> -               err =3D PTR_ERR(cache);
> -               if (IS_ERR(cache))
> -                       goto out;
> +                       cache =3D ovl_cache_get(dentry);
> +                       if (IS_ERR(cache))
> +                               return PTR_ERR(cache);
>
> -               od->cache =3D cache;
> -               ovl_seek_cursor(od, ctx->pos);
> -       }
> +                       od->cache =3D cache;
> +                       ovl_seek_cursor(od, ctx->pos);
> +               }
>
> -       while (od->cursor !=3D &od->cache->entries) {
> -               p =3D list_entry(od->cursor, struct ovl_cache_entry, l_no=
de);
> -               if (!p->is_whiteout) {
> -                       if (!p->ino || p->check_xwhiteout) {
> -                               err =3D ovl_cache_update(&file->f_path, p=
, !p->ino);
> -                               if (err)
> -                                       goto out;
> +               while (od->cursor !=3D &od->cache->entries) {
> +                       p =3D list_entry(od->cursor, struct ovl_cache_ent=
ry, l_node);
> +                       if (!p->is_whiteout) {
> +                               if (!p->ino || p->check_xwhiteout) {
> +                                       err =3D ovl_cache_update(&file->f=
_path, p, !p->ino);
> +                                       if (err)
> +                                               return err;
> +                               }
>                         }
> +                       /* ovl_cache_update() sets is_whiteout on stale e=
ntry */
> +                       if (!p->is_whiteout) {
> +                               if (!dir_emit(ctx, p->name, p->len, p->in=
o, p->type))
> +                                       break;
> +                       }
> +                       od->cursor =3D p->l_node.next;
> +                       ctx->pos++;
>                 }
> -               /* ovl_cache_update() sets is_whiteout on stale entry */
> -               if (!p->is_whiteout) {
> -                       if (!dir_emit(ctx, p->name, p->len, p->ino, p->ty=
pe))
> -                               break;
> -               }
> -               od->cursor =3D p->l_node.next;
> -               ctx->pos++;
> +               err =3D 0;
>         }
> -       err =3D 0;
> -out:
> -       ovl_revert_creds(old_cred);
>         return err;
>  }
>
>
> --
> 2.47.3
>

--000000000000dd3cfb06437a56d2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ovl-refactor-ovl_iterate-and-port-to-cred-guard.patch"
Content-Disposition: attachment; 
	filename="0001-ovl-refactor-ovl_iterate-and-port-to-cred-guard.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mhxi0vd60>
X-Attachment-Id: f_mhxi0vd60

RnJvbSBkYzExMDU5ZGMxMmQyOTQ1OTEyMjc5NTg1NmJhOGVkOTMzNGY3N2Q4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDEzIE5vdiAyMDI1IDE0OjU4OjMyICswMTAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiByZWZhY3RvciBvdmxfaXRlcmF0ZSgpIGFuZCBwb3J0IHRvIGNyZWQgZ3VhcmQKCmZhY3RvciBv
dXQgb3ZsX2l0ZXJhdGVfbWVyZ2VkKCkgYW5kIG1vdmUgc29tZSBjb2RlIGludG8Kb3ZsX2l0ZXJh
dGVfcmVhbCgpIGZvciBlYXNpZXIgdXNlIG9mIHRoZSBzY29wZWQgb3ZsIGNyZWQgZ3VhcmQuCgpT
aWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgotLS0KIGZz
L292ZXJsYXlmcy9yZWFkZGlyLmMgfCA2MCArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCAzMCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvcmVhZGRpci5jIGIvZnMvb3ZlcmxheWZz
L3JlYWRkaXIuYwppbmRleCA2YzllMDVjOWIzOWM0Li44OTc3ZDcyOWU4ZTQyIDEwMDY0NAotLS0g
YS9mcy9vdmVybGF5ZnMvcmVhZGRpci5jCisrKyBiL2ZzL292ZXJsYXlmcy9yZWFkZGlyLmMKQEAg
LTgwNCw2ICs4MDQsMTggQEAgc3RhdGljIGludCBvdmxfaXRlcmF0ZV9yZWFsKHN0cnVjdCBmaWxl
ICpmaWxlLCBzdHJ1Y3QgZGlyX2NvbnRleHQgKmN0eCkKIAkJLnhpbm93YXJuID0gb3ZsX3hpbm9f
d2FybihvZnMpLAogCX07CiAKKwkvKgorCSAqIFdpdGggeGlubywgd2UgbmVlZCB0byBhZGp1c3Qg
ZF9pbm8gb2YgbG93ZXIgZW50cmllcy4KKwkgKiBPbiBzYW1lIGZzLCBpZiBwYXJlbnQgaXMgbWVy
Z2UsIHRoZW4gbmVlZCB0byBhZGp1c3QgZF9pbm8gZm9yICcuLicsCisJICogYW5kIGlmIGRpciBp
cyBpbXB1cmUgdGhlbiBuZWVkIHRvIGFkanVzdCBkX2lubyBmb3IgY29waWVkIHVwIGVudHJpZXMu
CisJICogT3RoZXJ3aXNlLCB3ZSBjYW4gaXRlcmF0ZSB0aGUgcmVhbCBkaXIgZGlyZWN0bHkuCisJ
ICovCisJaWYgKCFvdmxfeGlub19iaXRzKG9mcykgJiYKKwkgICAgIShvdmxfc2FtZV9mcyhvZnMp
ICYmCisJICAgICAgKG92bF9pc19pbXB1cmVfZGlyKGZpbGUpIHx8CisJICAgICAgIE9WTF9UWVBF
X01FUkdFKG92bF9wYXRoX3R5cGUoZGlyLT5kX3BhcmVudCkpKSkpCisJCXJldHVybiBpdGVyYXRl
X2RpcihvZC0+cmVhbGZpbGUsIGN0eCk7CisKIAlpZiAocmR0Lnhpbm9iaXRzICYmIGxvd2VyX2xh
eWVyKQogCQlyZHQuZnNpZCA9IGxvd2VyX2xheWVyLT5mc2lkOwogCkBAIC04MzIsNDQgKzg0NCwy
MCBAQCBzdGF0aWMgaW50IG92bF9pdGVyYXRlX3JlYWwoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVj
dCBkaXJfY29udGV4dCAqY3R4KQogCXJldHVybiBlcnI7CiB9CiAKLQotc3RhdGljIGludCBvdmxf
aXRlcmF0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGRpcl9jb250ZXh0ICpjdHgpCitzdGF0
aWMgaW50IG92bF9pdGVyYXRlX21lcmdlZChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGRpcl9j
b250ZXh0ICpjdHgpCiB7CiAJc3RydWN0IG92bF9kaXJfZmlsZSAqb2QgPSBmaWxlLT5wcml2YXRl
X2RhdGE7CiAJc3RydWN0IGRlbnRyeSAqZGVudHJ5ID0gZmlsZS0+Zl9wYXRoLmRlbnRyeTsKLQlz
dHJ1Y3Qgb3ZsX2ZzICpvZnMgPSBPVkxfRlMoZGVudHJ5LT5kX3NiKTsKIAlzdHJ1Y3Qgb3ZsX2Nh
Y2hlX2VudHJ5ICpwOwotCWNvbnN0IHN0cnVjdCBjcmVkICpvbGRfY3JlZDsKIAlpbnQgZXJyOwog
Ci0Jb2xkX2NyZWQgPSBvdmxfb3ZlcnJpZGVfY3JlZHMoZGVudHJ5LT5kX3NiKTsKLQlpZiAoIWN0
eC0+cG9zKQotCQlvdmxfZGlyX3Jlc2V0KGZpbGUpOwotCi0JaWYgKG9kLT5pc19yZWFsKSB7Ci0J
CS8qCi0JCSAqIElmIHBhcmVudCBpcyBtZXJnZSwgdGhlbiBuZWVkIHRvIGFkanVzdCBkX2lubyBm
b3IgJy4uJywgaWYKLQkJICogZGlyIGlzIGltcHVyZSB0aGVuIG5lZWQgdG8gYWRqdXN0IGRfaW5v
IGZvciBjb3BpZWQgdXAKLQkJICogZW50cmllcy4KLQkJICovCi0JCWlmIChvdmxfeGlub19iaXRz
KG9mcykgfHwKLQkJICAgIChvdmxfc2FtZV9mcyhvZnMpICYmCi0JCSAgICAgKG92bF9pc19pbXB1
cmVfZGlyKGZpbGUpIHx8Ci0JCSAgICAgIE9WTF9UWVBFX01FUkdFKG92bF9wYXRoX3R5cGUoZGVu
dHJ5LT5kX3BhcmVudCkpKSkpIHsKLQkJCWVyciA9IG92bF9pdGVyYXRlX3JlYWwoZmlsZSwgY3R4
KTsKLQkJfSBlbHNlIHsKLQkJCWVyciA9IGl0ZXJhdGVfZGlyKG9kLT5yZWFsZmlsZSwgY3R4KTsK
LQkJfQotCQlnb3RvIG91dDsKLQl9Ci0KIAlpZiAoIW9kLT5jYWNoZSkgewogCQlzdHJ1Y3Qgb3Zs
X2Rpcl9jYWNoZSAqY2FjaGU7CiAKIAkJY2FjaGUgPSBvdmxfY2FjaGVfZ2V0KGRlbnRyeSk7CiAJ
CWVyciA9IFBUUl9FUlIoY2FjaGUpOwogCQlpZiAoSVNfRVJSKGNhY2hlKSkKLQkJCWdvdG8gb3V0
OworCQkJcmV0dXJuIGVycjsKIAogCQlvZC0+Y2FjaGUgPSBjYWNoZTsKIAkJb3ZsX3NlZWtfY3Vy
c29yKG9kLCBjdHgtPnBvcyk7CkBAIC04ODEsNyArODY5LDcgQEAgc3RhdGljIGludCBvdmxfaXRl
cmF0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGRpcl9jb250ZXh0ICpjdHgpCiAJCQlpZiAo
IXAtPmlubyB8fCBwLT5jaGVja194d2hpdGVvdXQpIHsKIAkJCQllcnIgPSBvdmxfY2FjaGVfdXBk
YXRlKCZmaWxlLT5mX3BhdGgsIHAsICFwLT5pbm8pOwogCQkJCWlmIChlcnIpCi0JCQkJCWdvdG8g
b3V0OworCQkJCQlyZXR1cm4gZXJyOwogCQkJfQogCQl9CiAJCS8qIG92bF9jYWNoZV91cGRhdGUo
KSBzZXRzIGlzX3doaXRlb3V0IG9uIHN0YWxlIGVudHJ5ICovCkBAIC04OTIsMTIgKzg4MCwyNCBA
QCBzdGF0aWMgaW50IG92bF9pdGVyYXRlKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgZGlyX2Nv
bnRleHQgKmN0eCkKIAkJb2QtPmN1cnNvciA9IHAtPmxfbm9kZS5uZXh0OwogCQljdHgtPnBvcysr
OwogCX0KLQllcnIgPSAwOwotb3V0OgotCW92bF9yZXZlcnRfY3JlZHMob2xkX2NyZWQpOwogCXJl
dHVybiBlcnI7CiB9CiAKK3N0YXRpYyBpbnQgb3ZsX2l0ZXJhdGUoc3RydWN0IGZpbGUgKmZpbGUs
IHN0cnVjdCBkaXJfY29udGV4dCAqY3R4KQoreworCXN0cnVjdCBvdmxfZGlyX2ZpbGUgKm9kID0g
ZmlsZS0+cHJpdmF0ZV9kYXRhOworCisJaWYgKCFjdHgtPnBvcykKKwkJb3ZsX2Rpcl9yZXNldChm
aWxlKTsKKworCXdpdGhfb3ZsX2NyZWRzKGZpbGUtPmZfcGF0aC5kZW50cnktPmRfc2IpIHsKKwkJ
aWYgKG9kLT5pc19yZWFsKQorCQkJcmV0dXJuIG92bF9pdGVyYXRlX3JlYWwoZmlsZSwgY3R4KTsK
KwkJZWxzZQorCQkJcmV0dXJuIG92bF9pdGVyYXRlX21lcmdlZChmaWxlLCBjdHgpOworCX0KK30K
Kwogc3RhdGljIGxvZmZfdCBvdmxfZGlyX2xsc2VlayhzdHJ1Y3QgZmlsZSAqZmlsZSwgbG9mZl90
IG9mZnNldCwgaW50IG9yaWdpbikKIHsKIAlsb2ZmX3QgcmVzOwotLSAKMi41MS4xCgo=
--000000000000dd3cfb06437a56d2--
