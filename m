MIME-Version: 1.0
In-Reply-To: <20180903061211.20830-2-amir73il@gmail.com>
References: <20180903061211.20830-1-amir73il@gmail.com>
	<20180903061211.20830-2-amir73il@gmail.com>
Date: Wed, 24 Oct 2018 16:16:19 +0200
Message-ID: <CAJfpegs_MTifkPKX4g9Z-BOe4pGjYJFno9B3tp-96znLJ7hW1A@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: relax requirement for non null uuid of lower fs
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: multipart/mixed; boundary="0000000000004a30a40578fa218d"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

--0000000000004a30a40578fa218d
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 3, 2018 at 8:12 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> We use uuid to associate an overlay lower file handle with a lower layer,
> so we can accept lower fs with null uuid as long as all lower layers with
> null uuid are on the same fs.
>
> This change allows enabling index and nfs_export features for the setup of
> single lower fs of type squashfs - squashfs supports file handles, but has
> a null uuid. This change also allows enabling index and nfs_export
> features for nested overlayfs, where the lower overlay has nfs_export
> enabled.

Shouldn't overlayfs generate an uuid for the nested case?  Not quite
sure what's the best way to do that, though...

>
> Enabling the index feature with single lower squashfs fixes the
> unionmount-testsuite test:
>   ./run --ov --squashfs --verify
>
> As a by-product, if, like the lower squashfs, upper fs also uses the
> generic export_encode_fh() implementation to export 32bit inode file
> handles (e.g. ext4), then the xino_auto config/module/mount option will
> enable unique overlay inode numbers.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 23 +++++++++++++++++++++--
>  fs/overlayfs/util.c  |  3 +--
>  2 files changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 2e0fc93c2c06..069e441e24eb 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1174,11 +1174,14 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
>  }
>
>  /* Get a unique fsid for the layer */
> -static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
> +static int ovl_get_fsid(struct ovl_fs *ofs, struct vfsmount *mnt)
>  {
> +       struct super_block *sb = mnt->mnt_sb;
>         unsigned int i;
>         dev_t dev;
>         int err;
> +       bool need_uuid = ofs->config.nfs_export ||
> +                        (ofs->config.index && ofs->upper_mnt);
>
>         /* fsid 0 is reserved for upper fs even with non upper overlay */
>         if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
> @@ -1187,6 +1190,22 @@ static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
>         for (i = 0; i < ofs->numlowerfs; i++) {
>                 if (ofs->lower_fs[i].sb == sb)
>                         return i + 1;
> +
> +               /*
> +                * We use uuid to associate an overlay lower file handle with a
> +                * lower layer, so we can accept lower fs with null uuid as long
> +                * as all lower layers with null uuid are on the same fs.
> +                */
> +               if (need_uuid &&
> +                   uuid_equal(&ofs->lower_fs[i].sb->s_uuid, &sb->s_uuid)) {
> +                       need_uuid = false;
> +                       ofs->config.index = false;
> +                       ofs->config.nfs_export = false;
> +                       pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
> +                               uuid_is_null(&sb->s_uuid) ? "null" :
> +                                                           "conflicting",
> +                               mnt->mnt_root);

mnt->mnt_root is wrong here: this is path->mnt resolved from the
lowerdir, not the one cloned from that path.

Fixed so ovl_get_lower_layers() passes in the path, not just the mount.

Also made this a separate loop from the one finding a matching fs, as
it's logically a different step and not needed in the case when the fs
is found.

Updated but untested patch attached.

Thanks,
Miklos

--0000000000004a30a40578fa218d
Content-Type: text/x-patch; charset="US-ASCII";
	name="ovl-relax-requirement-for-non-null-uuid-of-lower-fs.patch"
Content-Disposition: attachment;
	filename="ovl-relax-requirement-for-non-null-uuid-of-lower-fs.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jnn8q5h20

RnJvbTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KU3ViamVjdDogb3ZsOiBy
ZWxheCByZXF1aXJlbWVudCBmb3Igbm9uIG51bGwgdXVpZCBvZiBsb3dlciBmcwpEYXRlOiBNb24s
ICAzIFNlcCAyMDE4IDA5OjEyOjA5ICswMzAwCgpXZSB1c2UgdXVpZCB0byBhc3NvY2lhdGUgYW4g
b3ZlcmxheSBsb3dlciBmaWxlIGhhbmRsZSB3aXRoIGEgbG93ZXIgbGF5ZXIsCnNvIHdlIGNhbiBh
Y2NlcHQgbG93ZXIgZnMgd2l0aCBudWxsIHV1aWQgYXMgbG9uZyBhcyBhbGwgbG93ZXIgbGF5ZXJz
IHdpdGgKbnVsbCB1dWlkIGFyZSBvbiB0aGUgc2FtZSBmcy4KClRoaXMgY2hhbmdlIGFsbG93cyBl
bmFibGluZyBpbmRleCBhbmQgbmZzX2V4cG9ydCBmZWF0dXJlcyBmb3IgdGhlIHNldHVwIG9mCnNp
bmdsZSBsb3dlciBmcyBvZiB0eXBlIHNxdWFzaGZzIC0gc3F1YXNoZnMgc3VwcG9ydHMgZmlsZSBo
YW5kbGVzLCBidXQgaGFzCmEgbnVsbCB1dWlkLiBUaGlzIGNoYW5nZSBhbHNvIGFsbG93cyBlbmFi
bGluZyBpbmRleCBhbmQgbmZzX2V4cG9ydApmZWF0dXJlcyBmb3IgbmVzdGVkIG92ZXJsYXlmcywg
d2hlcmUgdGhlIGxvd2VyIG92ZXJsYXkgaGFzIG5mc19leHBvcnQKZW5hYmxlZC4KCkVuYWJsaW5n
IHRoZSBpbmRleCBmZWF0dXJlIHdpdGggc2luZ2xlIGxvd2VyIHNxdWFzaGZzIGZpeGVzIHRoZQp1
bmlvbm1vdW50LXRlc3RzdWl0ZSB0ZXN0OgogIC4vcnVuIC0tb3YgLS1zcXVhc2hmcyAtLXZlcmlm
eQoKQXMgYSBieS1wcm9kdWN0LCBpZiwgbGlrZSB0aGUgbG93ZXIgc3F1YXNoZnMsIHVwcGVyIGZz
IGFsc28gdXNlcyB0aGUKZ2VuZXJpYyBleHBvcnRfZW5jb2RlX2ZoKCkgaW1wbGVtZW50YXRpb24g
dG8gZXhwb3J0IDMyYml0IGlub2RlIGZpbGUKaGFuZGxlcyAoZS5nLiBleHQ0KSwgdGhlbiB0aGUg
eGlub19hdXRvIGNvbmZpZy9tb2R1bGUvbW91bnQgb3B0aW9uIHdpbGwKZW5hYmxlIHVuaXF1ZSBv
dmVybGF5IGlub2RlIG51bWJlcnMuCgpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1p
cjczaWxAZ21haWwuY29tPgotLS0KIGZzL292ZXJsYXlmcy9zdXBlci5jIHwgICAzMiArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLQogZnMvb3ZlcmxheWZzL3V0aWwuYyAgfCAgICAzICst
LQogMiBmaWxlcyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKLS0t
IGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMKKysrIGIvZnMvb3ZlcmxheWZzL3N1cGVyLmMKQEAgLTEx
NzUsOSArMTE3NSwyOSBAQCBzdGF0aWMgaW50IG92bF9nZXRfaW5kZXhkaXIoc3RydWN0IG92bF9m
CiAJcmV0dXJuIGVycjsKIH0KIAorc3RhdGljIGJvb2wgb3ZsX2xvd2VyX3V1aWRfb2soc3RydWN0
IG92bF9mcyAqb2ZzLCBjb25zdCB1dWlkX3QgKnV1aWQpCit7CisJdW5zaWduZWQgaW50IGk7CisK
KwlpZiAoIW9mcy0+Y29uZmlnLm5mc19leHBvcnQgJiYgIShvZnMtPmNvbmZpZy5pbmRleCAmJiBv
ZnMtPnVwcGVyX21udCkpCisJCXJldHVybiB0cnVlOworCisJZm9yIChpID0gMDsgaSA8IG9mcy0+
bnVtbG93ZXJmczsgaSsrKSB7CisJCS8qCisJCSAqIFdlIHVzZSB1dWlkIHRvIGFzc29jaWF0ZSBh
biBvdmVybGF5IGxvd2VyIGZpbGUgaGFuZGxlIHdpdGggYQorCQkgKiBsb3dlciBsYXllciwgc28g
d2UgY2FuIGFjY2VwdCBsb3dlciBmcyB3aXRoIG51bGwgdXVpZCBhcyBsb25nCisJCSAqIGFzIGFs
bCBsb3dlciBsYXllcnMgd2l0aCBudWxsIHV1aWQgYXJlIG9uIHRoZSBzYW1lIGZzLgorCQkgKi8K
KwkJaWYgKHV1aWRfZXF1YWwoJm9mcy0+bG93ZXJfZnNbaV0uc2ItPnNfdXVpZCwgdXVpZCkpCisJ
CQlyZXR1cm4gZmFsc2U7CisJfQorCXJldHVybiB0cnVlOworfQorCiAvKiBHZXQgYSB1bmlxdWUg
ZnNpZCBmb3IgdGhlIGxheWVyICovCi1zdGF0aWMgaW50IG92bF9nZXRfZnNpZChzdHJ1Y3Qgb3Zs
X2ZzICpvZnMsIHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCitzdGF0aWMgaW50IG92bF9nZXRfZnNp
ZChzdHJ1Y3Qgb3ZsX2ZzICpvZnMsIGNvbnN0IHN0cnVjdCBwYXRoICpwYXRoKQogeworCXN0cnVj
dCBzdXBlcl9ibG9jayAqc2IgPSBwYXRoLT5tbnQtPm1udF9zYjsKIAl1bnNpZ25lZCBpbnQgaTsK
IAlkZXZfdCBkZXY7CiAJaW50IGVycjsKQEAgLTExOTEsNiArMTIxMSwxNCBAQCBzdGF0aWMgaW50
IG92bF9nZXRfZnNpZChzdHJ1Y3Qgb3ZsX2ZzICpvCiAJCQlyZXR1cm4gaSArIDE7CiAJfQogCisJ
aWYgKCFvdmxfbG93ZXJfdXVpZF9vayhvZnMsICZzYi0+c191dWlkKSkgeworCQlvZnMtPmNvbmZp
Zy5pbmRleCA9IGZhbHNlOworCQlvZnMtPmNvbmZpZy5uZnNfZXhwb3J0ID0gZmFsc2U7CisJCXBy
X3dhcm4oIm92ZXJsYXlmczogJXMgdXVpZCBkZXRlY3RlZCBpbiBsb3dlciBmcyAnJXBkMicsIGZh
bGxpbmcgYmFjayB0byBpbmRleD1vZmYsbmZzX2V4cG9ydD1vZmYuXG4iLAorCQkJdXVpZF9pc19u
dWxsKCZzYi0+c191dWlkKSA/ICJudWxsIiA6ICJjb25mbGljdGluZyIsCisJCQlwYXRoLT5kZW50
cnkpOworCX0KKwogCWVyciA9IGdldF9hbm9uX2JkZXYoJmRldik7CiAJaWYgKGVycikgewogCQlw
cl9lcnIoIm92ZXJsYXlmczogZmFpbGVkIHRvIGdldCBhbm9ueW1vdXMgYmRldiBmb3IgbG93ZXJw
YXRoXG4iKTsKQEAgLTEyMjUsNyArMTI1Myw3IEBAIHN0YXRpYyBpbnQgb3ZsX2dldF9sb3dlcl9s
YXllcnMoc3RydWN0IG8KIAkJc3RydWN0IHZmc21vdW50ICptbnQ7CiAJCWludCBmc2lkOwogCi0J
CWVyciA9IGZzaWQgPSBvdmxfZ2V0X2ZzaWQob2ZzLCBzdGFja1tpXS5tbnQtPm1udF9zYik7CisJ
CWVyciA9IGZzaWQgPSBvdmxfZ2V0X2ZzaWQob2ZzLCAmc3RhY2tbaV0pOwogCQlpZiAoZXJyIDwg
MCkKIAkJCWdvdG8gb3V0OwogCi0tLSBhL2ZzL292ZXJsYXlmcy91dGlsLmMKKysrIGIvZnMvb3Zl
cmxheWZzL3V0aWwuYwpAQCAtNjUsOCArNjUsNyBAQCBzdHJ1Y3Qgc3VwZXJfYmxvY2sgKm92bF9z
YW1lX3NiKHN0cnVjdCBzCiAgKi8KIGludCBvdmxfY2FuX2RlY29kZV9maChzdHJ1Y3Qgc3VwZXJf
YmxvY2sgKnNiKQogewotCWlmICghc2ItPnNfZXhwb3J0X29wIHx8ICFzYi0+c19leHBvcnRfb3At
PmZoX3RvX2RlbnRyeSB8fAotCSAgICB1dWlkX2lzX251bGwoJnNiLT5zX3V1aWQpKQorCWlmICgh
c2ItPnNfZXhwb3J0X29wIHx8ICFzYi0+c19leHBvcnRfb3AtPmZoX3RvX2RlbnRyeSkKIAkJcmV0
dXJuIDA7CiAKIAlyZXR1cm4gc2ItPnNfZXhwb3J0X29wLT5lbmNvZGVfZmggPyAtMSA6IEZJTEVJ
RF9JTk8zMl9HRU47Cg==
--0000000000004a30a40578fa218d--
