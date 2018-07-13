Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180712213230.157085-1-adityakali@gooogle.com>
References: <20180712213230.157085-1-adityakali@gooogle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 13 Jul 2018 16:09:36 +0300
Message-ID: <CAOQ4uxj9dvgzVg3EX0q9qX6U4C-DJbs1Ph+Pj+o=8ubmYO0q8A@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: fix warning in ovl_iterate
Content-Type: multipart/mixed; boundary="0000000000001676120570e131d5"
To: Aditya Kali <adityakali@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

--0000000000001676120570e131d5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 13, 2018 at 12:32 AM, Aditya Kali <adityakali@google.com> wrote=
:
> From: Aditya Kali <adityakali@google.com>
>
> In ovl_iterate() funciton, we were calling ovl_cache_get() on dentries
> marked OVL_IMPURE which are not refcounted. This results in triggering
> WARN_ON(cache->refcount <=3D 0).

Aditya,

Thanks for the report, but I am afraid your analysis is inaccurate and
the fix is flat out wrong, so let's try to better understand what is going =
on.

First of all, the WARNING triggered by your test in WARN_ON(!cache->refcoun=
t)
at line 415 of  ovl_cache_get() and not the warning in ovl_cache_put().

Your statement that dir marked OVL_IMPURE have non refcounted
dir cache is not accurate.
This statement is only true for dirs that are !ovl_dir_is_real() AND
marked OVL_IMPURE, in which case od->cache should be NULL
and therefore ovl_cache_put() is not concerned.

Since your test case hits the WARN_ON in ovl_cache_get() it suggests
that the dir was ovl_dir_is_real(), got a dir cache initialized with
ovl_cache_get_impure() and then later became !ovl_dir_is_real()
and got passed into  ovl_cache_get() with an unexpected type
of dir cache.

Directory can only become !ovl_dir_is_real() on copy up and if dir
was not upper prior to copy up, it could not have been OVL_IMPURE
either. However, if ovl_iterate() is called with non zero ctx->pos,
od->is_real will not be updated, but OVL_IMPURE is checked again.
Meaning that if chown -R iterates on a bunch of files, chowns them
and then continues to iterate on more files, directory will become
OVL_IMPURE, so second ovl_iterate() call with non zero ctx->pos
will initialize an impure dir cache and then on following ls -l we will
hit the WARNING.

It will be nice if you can add traces in the relevant functions to prove
this is what's happening in your test case.

> It can be reproduced by running the following command (on system with
> docker using overlay2 graph driver):
>
>   docker run --rm drupal:8.5.4-fpm-alpine \
>     sh -c 'cd /var/www/html/vendor/symfony && chown -R www-data:www-data =
. && ls -l .'

It's nice to have a one liner reproducer, but if you can come up with
a simple script reproducer that does not include docker that would be
even nicer.
If you write an xfstest for the reproducer you really get the praises ;-)

>
>   # dmesg shows
>
>   [  509.446081] WARNING: CPU: 3 PID: 4964 at fs/overlayfs/readdir.c:415 =
ovl_iterate+0x25b/0x270 [overlay]
>   [  509.455437] Modules linked in: veth ipt_MASQUERADE nf_conntrack_netl=
ink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_i=
pv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack=
 libcrc32c br_netfilter bridge stp llc overlay sb_edac crct10dif_pclmul crc=
32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd crypt=
d evdev glue_helper pvpanic sg serio_raw snd_pcsp button snd_pcm snd_timer =
snd soundcore intel_rapl_perf ip_tables x_tables autofs4 ext4 crc32c_generi=
c crc16 mbcache jbd2 fscrypto sd_mod virtio_scsi virtio_net net_failover sc=
si_mod failover crc32c_intel virtio_pci psmouse virtio_ring i2c_piix4 virti=
o
>   [  509.514107] CPU: 3 PID: 4964 Comm: ls Not tainted 4.18.0-rc4+ #1
>   [  509.520217] Hardware name: Google Google Compute Engine/Google Compu=
te Engine, BIOS Google 01/01/2011
>   [  509.529545] RIP: 0010:ovl_iterate+0x25b/0x270 [overlay]
>   [  509.534899] Code: ff 89 44 24 04 e8 c5 f7 ff ff 4c 89 f7 e8 6d d0 9e=
 df 4c 63 74 24 04 eb a2 49 8b 06 48 85 c0 74 09 48 83 c0 01 49 89 06 eb 91=
 <0f> 0b eb f3 44 89 f0 e9 9f fe ff ff 66 0f 1f 84 00 00 00 00 00 0f
>   [  509.553889] RSP: 0018:ffffa677c3f1fe40 EFLAGS: 00010246
>   [  509.559228] RAX: 0000000000000000 RBX: ffff8acee1e99480 RCX: ffff8ac=
f57973c40
>   [  509.566483] RDX: ffffffff00000001 RSI: ffff8acee1ee8020 RDI: ffff8ac=
ee1e99480
>   [  509.573754] RBP: ffffa677c3f1fed0 R08: 0000000000000000 R09: 0000000=
000000000
>   [  509.581000] R10: ffffa677c3f1fe80 R11: 0000000000000000 R12: ffff8ac=
f3aa7f4c0
>   [  509.588239] R13: ffff8acf586b5a00 R14: ffff8acf3e02a240 R15: 0000000=
000000000
>   [  509.595477] FS:  00007fe259795b88(0000) GS:ffff8acf7fcc0000(0000) kn=
lGS:0000000000000000
>   [  509.603669] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [  509.609527] CR2: 00007fe25954086a CR3: 0000000795746003 CR4: 0000000=
0001606e0
>   [  509.616787] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
>   [  509.624025] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
>   [  509.631263] Call Trace:
>   [  509.633832]  iterate_dir+0x172/0x190
>   [  509.637515]  ksys_getdents64+0x9d/0x120
>   [  509.641457]  ? syscall_trace_enter+0x1ae/0x2c0
>   [  509.646009]  ? iterate_dir+0x190/0x190
>   [  509.649864]  ? __x64_sys_getdents64+0x16/0x20
>   [  509.654331]  __x64_sys_getdents64+0x16/0x20
>   [  509.658618]  do_syscall_64+0x55/0x100
>   [  509.662386]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   [  509.667545] RIP: 0033:0x7fe25952740e
>   [  509.671224] Code: 0f 05 eb 02 89 18 48 89 d0 5b c3 53 8b 47 14 49 89=
 f8 39 47 10 48 8d 77 20 7c 37 48 63 3f ba 00 08 00 00 b8 d9 00 00 00 0f 05=
 <85> c0 48 89 c3 7f 15 c1 e8 1f 74 3a 83 fb fe 74 35 f7 db e8 89 09
>   [  509.690203] RSP: 002b:00007ffd0d30fc60 EFLAGS: 00000246 ORIG_RAX: 00=
000000000000d9
>   [  509.697892] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe=
25952740e
>   [  509.705132] RDX: 0000000000000800 RSI: 00007fe2597961e0 RDI: 0000000=
000000003
>   [  509.712465] RBP: 0000000000000000 R08: 00007fe2597961c0 R09: 0000000=
000000000
>   [  509.719702] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558=
2eb183bc0
>   [  509.726956] R13: 00007fe2597961c0 R14: 0000000000000000 R15: 0000000=
000000001
>   [  509.734199] ---[ end trace 60478fe83a958f8f ]---
>
> Also reported at https://bugzilla.redhat.com/show_bug.cgi?id=3D1539540.
>
> Address this by making sure ovl_cache_get_impure() is called instead for
> the OVL_IMPURE dentries. Also handles OVL_IMPURE case in ovl_cache_put().
>
> Fixes: 4edb83bb1041 ('ovl: constant d_ino for non-merge dirs')
>
> Signed-off-by: Aditya Kali <adityakali@google.com>
> ---
>  fs/overlayfs/readdir.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index ef1fe42ff7bb..4e9ce0ccf1f1 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -241,10 +241,18 @@ void ovl_dir_cache_free(struct inode *inode)
>  static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dentry=
)
>  {
>         struct ovl_dir_cache *cache =3D od->cache;
> +       bool is_impure =3D ovl_test_flag(OVL_IMPURE, d_inode(dentry));
>
> -       WARN_ON(cache->refcount <=3D 0);
> -       cache->refcount--;
> -       if (!cache->refcount) {
> +       /*
> +        * OVL_IMPURE dentry cache is not refcounted. So free it
> +        * unconditionally.
> +        */
> +       if (!is_impure) {
> +               WARN_ON(cache->refcount <=3D 0);
> +               cache->refcount--;
> +       }
> +

Irrelevant - od->cache is never set to a non refcounted dir cache.

> +       if (!cache->refcount || is_impure) {
>                 if (ovl_dir_cache(d_inode(dentry)) =3D=3D cache)
>                         ovl_set_dir_cache(d_inode(dentry), NULL);
>
> @@ -737,7 +745,11 @@ static int ovl_iterate(struct file *file, struct dir=
_context *ctx)
>         if (!od->cache) {
>                 struct ovl_dir_cache *cache;
>
> -               cache =3D ovl_cache_get(dentry);
> +               if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)))
> +                       cache =3D ovl_cache_get_impure(&file->f_path);
> +               else
> +                       cache =3D ovl_cache_get(dentry);
> +

Totally wrong. If dir is_real() it needs a merged dir cache from
ovl_cache_get().

Please try attached patch.
It is works for you, feel free to add your report to commit message
add your Signed-off-by and post the patch.
Or let me know it works and I will post the patch with your Tested-by tag.

Thanks,
Amir.

--0000000000001676120570e131d5
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-ovl-fix-wrong-use-of-impure-dir-cache-in-ovl_iterate.patch"
Content-Disposition: attachment;
	filename="0001-ovl-fix-wrong-use-of-impure-dir-cache-in-ovl_iterate.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jjk01eb50

RnJvbSA5MzhhYTU4ODI4NTI4M2I0MTYxYTQwMzg3NTg3NDQ4YTEyNmMzM2M2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDEzIEp1bCAyMDE4IDE1OjUxOjI3ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBmaXggd3JvbmcgdXNlIG9mIGltcHVyZSBkaXIgY2FjaGUgaW4gb3ZsX2l0ZXJhdGUoKQoKT25s
eSB1cHBlciBkaXIgY2FuIGJlIGltcHVyZSwgYnV0IGlmIHdlIGFyZSBpbiB0aGUgbWlkZGxlIG9m
Cml0ZXJhdGluZyBhIGxvd2VyIHJlYWwgZGlyLCBkaXIgY291bGQgYmUgY29waWVkIHVwIGFuZCBt
YXJrZWQKaW1wdXJlLiBXZSBvbmx5IHdhbnQgdGhlIGltcHVyZSBjYWNoZSBpZiB3ZSBzdGFydGVk
IGl0ZXJhdGluZwphIHJlYWwgdXBwZXIgZGlyIHRvIGJlZ2luIHdpdGguCgpBZGl0eWEgS2FsaSBy
ZXBvcnRlZCB0aGF0IHRoZSBmb2xsb3dpbmcgcmVwcm9kdWNlciBoaXRzIHRoZQpXQVJOX09OKCFj
YWNoZS0+cmVmY291bnQpIGluIG92bF9nZXRfY2FjaGUoKToKCiBkb2NrZXIgcnVuIC0tcm0gZHJ1
cGFsOjguNS40LWZwbS1hbHBpbmUgXAogICAgc2ggLWMgJ2NkIC92YXIvd3d3L2h0bWwvdmVuZG9y
L3N5bWZvbnkgJiYgXAogICAgICAgICAgIGNob3duIC1SIHd3dy1kYXRhOnd3dy1kYXRhIC4gJiYg
bHMgLWwgLicKClJlcG9ydGVkLWJ5OiBBZGl0eWEgS2FsaSA8YWRpdHlha2FsaUBnb29nbGUuY29t
PgpGaXhlczogNGVkYjgzYmIxMDQxICgnb3ZsOiBjb25zdGFudCBkX2lubyBmb3Igbm9uLW1lcmdl
IGRpcnMnKQpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29t
PgotLS0KIGZzL292ZXJsYXlmcy9yZWFkZGlyLmMgfCAyMCArKysrKysrKysrKysrKy0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvb3ZlcmxheWZzL3JlYWRkaXIuYyBiL2ZzL292ZXJsYXlmcy9yZWFkZGlyLmMKaW5k
ZXggZWYxZmU0MmZmN2JiLi5iY2NiYjNlZTk5MzIgMTAwNjQ0Ci0tLSBhL2ZzL292ZXJsYXlmcy9y
ZWFkZGlyLmMKKysrIGIvZnMvb3ZlcmxheWZzL3JlYWRkaXIuYwpAQCAtNjk2LDcgKzY5NiwxMyBA
QCBzdGF0aWMgaW50IG92bF9pdGVyYXRlX3JlYWwoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBk
aXJfY29udGV4dCAqY3R4KQogCQlyZHQucGFyZW50X2lubyA9IHN0YXQuaW5vOwogCX0KIAotCWlm
IChvdmxfdGVzdF9mbGFnKE9WTF9JTVBVUkUsIGRfaW5vZGUoZGlyKSkpIHsKKwkvKgorCSAqIE9u
bHkgdXBwZXIgZGlyIGNhbiBiZSBpbXB1cmUsIGJ1dCBpZiB3ZSBhcmUgaW4gdGhlIG1pZGRsZSBv
ZgorCSAqIGl0ZXJhdGluZyBhIGxvd2VyIHJlYWwgZGlyLCBkaXIgY291bGQgYmUgY29waWVkIHVw
IGFuZCBtYXJrZWQKKwkgKiBpbXB1cmUuIFdlIG9ubHkgd2FudCB0aGUgaW1wdXJlIGNhY2hlIGlm
IHdlIHN0YXJ0ZWQgaXRlcmF0aW5nCisJICogYSByZWFsIHVwcGVyIGRpciB0byBiZWdpbiB3aXRo
LgorCSAqLworCWlmIChvZC0+aXNfdXBwZXIgJiYgb3ZsX3Rlc3RfZmxhZyhPVkxfSU1QVVJFLCBk
X2lub2RlKGRpcikpKSB7CiAJCXJkdC5jYWNoZSA9IG92bF9jYWNoZV9nZXRfaW1wdXJlKCZmaWxl
LT5mX3BhdGgpOwogCQlpZiAoSVNfRVJSKHJkdC5jYWNoZSkpCiAJCQlyZXR1cm4gUFRSX0VSUihy
ZHQuY2FjaGUpOwpAQCAtNzIxLDE0ICs3MjcsMTYgQEAgc3RhdGljIGludCBvdmxfaXRlcmF0ZShz
dHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGRpcl9jb250ZXh0ICpjdHgpCiAKIAlpZiAob2QtPmlz
X3JlYWwpIHsKIAkJLyoKLQkJICogSWYgcGFyZW50IGlzIG1lcmdlLCB0aGVuIG5lZWQgdG8gYWRq
dXN0IGRfaW5vIGZvciAnLi4nLCBpZgotCQkgKiBkaXIgaXMgaW1wdXJlIHRoZW4gbmVlZCB0byBh
ZGp1c3QgZF9pbm8gZm9yIGNvcGllZCB1cAotCQkgKiBlbnRyaWVzLgorCQkgKiBJZiB4aW5vIGlz
IGVuYWJsZWQsIG5lZWQgdG8gYWRqdXN0IGxvd2VyIGRfaW5vLgorCQkgKiBJZiBwYXJlbnQgaXMg
bWVyZ2UsIHRoZW4gbmVlZCB0byBhZGp1c3QgZF9pbm8gZm9yICcuLicuCisJCSAqIElmIGRpciBp
cyB1cHBlciBhbmQgaW1wdXJlIHRoZW4gbmVlZCB0byBhZGp1c3QgZF9pbm8gZm9yCisJCSAqIGNv
cGllZCB1cCBlbnRyaWVzLgogCQkgKi8KIAkJaWYgKG92bF94aW5vX2JpdHMoZGVudHJ5LT5kX3Ni
KSB8fAogCQkgICAgKG92bF9zYW1lX3NiKGRlbnRyeS0+ZF9zYikgJiYKLQkJICAgICAob3ZsX3Rl
c3RfZmxhZyhPVkxfSU1QVVJFLCBkX2lub2RlKGRlbnRyeSkpIHx8Ci0JCSAgICAgIE9WTF9UWVBF
X01FUkdFKG92bF9wYXRoX3R5cGUoZGVudHJ5LT5kX3BhcmVudCkpKSkpIHsKKwkJICAgICAoT1ZM
X1RZUEVfTUVSR0Uob3ZsX3BhdGhfdHlwZShkZW50cnktPmRfcGFyZW50KSkgfHwKKwkJICAgICAg
KG9kLT5pc191cHBlciAmJgorCQkgICAgICAgb3ZsX3Rlc3RfZmxhZyhPVkxfSU1QVVJFLCBkX2lu
b2RlKGRlbnRyeSkpKSkpKSB7CiAJCQlyZXR1cm4gb3ZsX2l0ZXJhdGVfcmVhbChmaWxlLCBjdHgp
OwogCQl9CiAJCXJldHVybiBpdGVyYXRlX2RpcihvZC0+cmVhbGZpbGUsIGN0eCk7Ci0tIAoyLjcu
NAoK
--0000000000001676120570e131d5--
