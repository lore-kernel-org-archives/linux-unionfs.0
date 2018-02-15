From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: hash directory inodes for fsnotify"
 failed to apply to 4.14-stable tree
Date: Thu, 15 Feb 2018 17:02:32 +0200
Message-ID: <CAOQ4uxhBfq2_J+190kkoTcr2FDYDYrF2J99opRLdDjMDpE-8RA@mail.gmail.com>
References: <151870507410538@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="94eb2c1882687396910565418416"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <151870507410538@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Niklas Cassel <niklas.cassel@axis.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

--94eb2c1882687396910565418416
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 15, 2018 at 4:31 PM,  <gregkh@linuxfoundation.org> wrote:
>
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

Hi Niklas,

The conflict resolution of this patch for v4.14 is trivial (just dropping last
hunk of inode.c patch), but I no means to test this right now.

Are you able and/or interested to test the attached backport path for
stable kernel v4.14?

I have posted an LTP test (inotify07) to test this fix if anyone else
is interested in testing:
https://github.com/linux-test-project/ltp/pull/246

Thanks,
Amir.

>
> ------------------ original commit in Linus's tree ------------------
>
> From 31747eda41ef3c30c09c5c096b380bf54013746a Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il@gmail.com>
> Date: Sun, 14 Jan 2018 18:35:40 +0200
> Subject: [PATCH] ovl: hash directory inodes for fsnotify
>
> fsnotify pins a watched directory inode in cache, but if directory dentry
> is released, new lookup will allocate a new dentry and a new inode.
> Directory events will be notified on the new inode, while fsnotify listener
> is watching the old pinned inode.
>
> Hash all directory inodes to reuse the pinned inode on lookup. Pure upper
> dirs are hashes by real upper inode, merge and lower dirs are hashed by
> real lower inode.
>
> The reference to lower inode was being held by the lower dentry object
> in the overlay dentry (oe->lowerstack[0]). Releasing the overlay dentry
> may drop lower inode refcount to zero. Add a refcount on behalf of the
> overlay inode to prevent that.
>
> As a by-product, hashing directory inodes also detects multiple
> redirected dirs to the same lower dir and uncovered redirected dir
> target on and returns -ESTALE on lookup.
>
> The reported issue dates back to initial version of overlayfs, but this
> patch depends on ovl_inode code that was introduced in kernel v4.13.
>
> Cc: <stable@vger.kernel.org> #v4.13
> Reported-by: Niklas Cassel <niklas.cassel@axis.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Tested-by: Niklas Cassel <niklas.cassel@axis.com>
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 00b6b294272a..94d2f8a8b779 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -606,6 +606,16 @@ static int ovl_inode_set(struct inode *inode, void *data)
>  static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
>                              struct dentry *upperdentry)
>  {
> +       if (S_ISDIR(inode->i_mode)) {
> +               /* Real lower dir moved to upper layer under us? */
> +               if (!lowerdentry && ovl_inode_lower(inode))
> +                       return false;
> +
> +               /* Lookup of an uncovered redirect origin? */
> +               if (!upperdentry && ovl_inode_upper(inode))
> +                       return false;
> +       }
> +
>         /*
>          * Allow non-NULL lower inode in ovl_inode even if lowerdentry is NULL.
>          * This happens when finding a copied up overlay inode for a renamed
> @@ -633,6 +643,8 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>         struct inode *inode;
>         /* Already indexed or could be indexed on copy up? */
>         bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
> +       struct dentry *origin = indexed ? lowerdentry : NULL;
> +       bool is_dir;
>
>         if (WARN_ON(upperdentry && indexed && !lowerdentry))
>                 return ERR_PTR(-EIO);
> @@ -641,15 +653,19 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>                 realinode = d_inode(lowerdentry);
>
>         /*
> -        * Copy up origin (lower) may exist for non-indexed upper, but we must
> -        * not use lower as hash key in that case.
> -        * Hash inodes that are or could be indexed by origin inode and
> -        * non-indexed upper inodes that could be hard linked by upper inode.
> +        * Copy up origin (lower) may exist for non-indexed non-dir upper, but
> +        * we must not use lower as hash key in that case.
> +        * Hash non-dir that is or could be indexed by origin inode.
> +        * Hash dir that is or could be merged by origin inode.
> +        * Hash pure upper and non-indexed non-dir by upper inode.
>          */
> -       if (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed)) {
> -               struct inode *key = d_inode(indexed ? lowerdentry :
> -                                                     upperdentry);
> -               unsigned int nlink;
> +       is_dir = S_ISDIR(realinode->i_mode);
> +       if (is_dir)
> +               origin = lowerdentry;
> +
> +       if (upperdentry || origin) {
> +               struct inode *key = d_inode(origin ?: upperdentry);
> +               unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
>
>                 inode = iget5_locked(dentry->d_sb, (unsigned long) key,
>                                      ovl_inode_test, ovl_inode_set, key);
> @@ -670,8 +686,9 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>                         goto out;
>                 }
>
> -               nlink = ovl_get_nlink(lowerdentry, upperdentry,
> -                                     realinode->i_nlink);
> +               /* Recalculate nlink for non-dir due to indexing */
> +               if (!is_dir)
> +                       nlink = ovl_get_nlink(lowerdentry, upperdentry, nlink);
>                 set_nlink(inode, nlink);
>         } else {
>                 inode = new_inode(dentry->d_sb);
> @@ -685,7 +702,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>                 ovl_set_flag(OVL_IMPURE, inode);
>
>         /* Check for non-merge dir that may have whiteouts */
> -       if (S_ISDIR(realinode->i_mode)) {
> +       if (is_dir) {
>                 struct ovl_entry *oe = dentry->d_fsdata;
>
>                 if (((upperdentry && lowerdentry) || oe->numlower > 1) ||
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440feb79f6..1a436fa92a04 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -211,6 +211,7 @@ static void ovl_destroy_inode(struct inode *inode)
>         struct ovl_inode *oi = OVL_I(inode);
>
>         dput(oi->__upperdentry);
> +       iput(oi->lower);
>         kfree(oi->redirect);
>         ovl_dir_cache_free(inode);
>         mutex_destroy(&oi->lock);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index d6bb1c9f5e7a..06119f34a69d 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -257,7 +257,7 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
>         if (upperdentry)
>                 OVL_I(inode)->__upperdentry = upperdentry;
>         if (lowerdentry)
> -               OVL_I(inode)->lower = d_inode(lowerdentry);
> +               OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
>
>         ovl_copyattr(d_inode(upperdentry ?: lowerdentry), inode);
>  }
> @@ -273,7 +273,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
>          */
>         smp_wmb();
>         OVL_I(inode)->__upperdentry = upperdentry;
> -       if (!S_ISDIR(upperinode->i_mode) && inode_unhashed(inode)) {
> +       if (inode_unhashed(inode)) {
>                 inode->i_private = upperinode;
>                 __insert_inode_hash(inode, (unsigned long) upperinode);
>         }
>

--94eb2c1882687396910565418416
Content-Type: text/x-patch; charset="US-ASCII";
	name="v4.14-backport-ovl-hash-directory-inodes-for-fsnotify.patch"
Content-Disposition: attachment;
	filename="v4.14-backport-ovl-hash-directory-inodes-for-fsnotify.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jdomqgxf0

RnJvbSAwYjdlNDliZWRiMjhlMWQzYTk2NTNiZTJjNTc1NDVmMDc0NDgxZmFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDE0IEphbiAyMDE4IDE4OjM1OjQwICswMjAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBoYXNoIGRpcmVjdG9yeSBpbm9kZXMgZm9yIGZzbm90aWZ5Cgpmc25vdGlmeSBwaW5zIGEgd2F0
Y2hlZCBkaXJlY3RvcnkgaW5vZGUgaW4gY2FjaGUsIGJ1dCBpZiBkaXJlY3RvcnkgZGVudHJ5Cmlz
IHJlbGVhc2VkLCBuZXcgbG9va3VwIHdpbGwgYWxsb2NhdGUgYSBuZXcgZGVudHJ5IGFuZCBhIG5l
dyBpbm9kZS4KRGlyZWN0b3J5IGV2ZW50cyB3aWxsIGJlIG5vdGlmaWVkIG9uIHRoZSBuZXcgaW5v
ZGUsIHdoaWxlIGZzbm90aWZ5IGxpc3RlbmVyCmlzIHdhdGNoaW5nIHRoZSBvbGQgcGlubmVkIGlu
b2RlLgoKSGFzaCBhbGwgZGlyZWN0b3J5IGlub2RlcyB0byByZXVzZSB0aGUgcGlubmVkIGlub2Rl
IG9uIGxvb2t1cC4gUHVyZSB1cHBlcgpkaXJzIGFyZSBoYXNoZXMgYnkgcmVhbCB1cHBlciBpbm9k
ZSwgbWVyZ2UgYW5kIGxvd2VyIGRpcnMgYXJlIGhhc2hlZCBieQpyZWFsIGxvd2VyIGlub2RlLgoK
VGhlIHJlZmVyZW5jZSB0byBsb3dlciBpbm9kZSB3YXMgYmVpbmcgaGVsZCBieSB0aGUgbG93ZXIg
ZGVudHJ5IG9iamVjdAppbiB0aGUgb3ZlcmxheSBkZW50cnkgKG9lLT5sb3dlcnN0YWNrWzBdKS4g
UmVsZWFzaW5nIHRoZSBvdmVybGF5IGRlbnRyeQptYXkgZHJvcCBsb3dlciBpbm9kZSByZWZjb3Vu
dCB0byB6ZXJvLiBBZGQgYSByZWZjb3VudCBvbiBiZWhhbGYgb2YgdGhlCm92ZXJsYXkgaW5vZGUg
dG8gcHJldmVudCB0aGF0LgoKQXMgYSBieS1wcm9kdWN0LCBoYXNoaW5nIGRpcmVjdG9yeSBpbm9k
ZXMgYWxzbyBkZXRlY3RzIG11bHRpcGxlCnJlZGlyZWN0ZWQgZGlycyB0byB0aGUgc2FtZSBsb3dl
ciBkaXIgYW5kIHVuY292ZXJlZCByZWRpcmVjdGVkIGRpcgp0YXJnZXQgb24gYW5kIHJldHVybnMg
LUVTVEFMRSBvbiBsb29rdXAuCgpUaGUgcmVwb3J0ZWQgaXNzdWUgZGF0ZXMgYmFjayB0byBpbml0
aWFsIHZlcnNpb24gb2Ygb3ZlcmxheWZzLCBidXQgdGhpcwpwYXRjaCBkZXBlbmRzIG9uIG92bF9p
bm9kZSBjb2RlIHRoYXQgd2FzIGludHJvZHVjZWQgaW4ga2VybmVsIHY0LjEzLgoKQ2M6IDxzdGFi
bGVAdmdlci5rZXJuZWwub3JnPiAjdjQuMTMKUmVwb3J0ZWQtYnk6IE5pa2xhcyBDYXNzZWwgPG5p
a2xhcy5jYXNzZWxAYXhpcy5jb20+ClNpZ25lZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWly
NzNpbEBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IE1pa2xvcyBTemVyZWRpIDxtc3plcmVkaUBy
ZWRoYXQuY29tPgpUZXN0ZWQtYnk6IE5pa2xhcyBDYXNzZWwgPG5pa2xhcy5jYXNzZWxAYXhpcy5j
b20+Ci0tLQogZnMvb3ZlcmxheWZzL2lub2RlLmMgfCAzNyArKysrKysrKysrKysrKysrKysrKysr
KysrKystLS0tLS0tLS0tCiBmcy9vdmVybGF5ZnMvc3VwZXIuYyB8ICAxICsKIGZzL292ZXJsYXlm
cy91dGlsLmMgIHwgIDQgKystLQogMyBmaWxlcyBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCAx
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvaW5vZGUuYyBiL2ZzL292
ZXJsYXlmcy9pbm9kZS5jCmluZGV4IDMyMTUxMWVkOGM0Mi4uZDYwOTAwYjYxNWY5IDEwMDY0NAot
LS0gYS9mcy9vdmVybGF5ZnMvaW5vZGUuYworKysgYi9mcy9vdmVybGF5ZnMvaW5vZGUuYwpAQCAt
NTc5LDYgKzU3OSwxNiBAQCBzdGF0aWMgaW50IG92bF9pbm9kZV9zZXQoc3RydWN0IGlub2RlICpp
bm9kZSwgdm9pZCAqZGF0YSkKIHN0YXRpYyBib29sIG92bF92ZXJpZnlfaW5vZGUoc3RydWN0IGlu
b2RlICppbm9kZSwgc3RydWN0IGRlbnRyeSAqbG93ZXJkZW50cnksCiAJCQkgICAgIHN0cnVjdCBk
ZW50cnkgKnVwcGVyZGVudHJ5KQogeworCWlmIChTX0lTRElSKGlub2RlLT5pX21vZGUpKSB7CisJ
CS8qIFJlYWwgbG93ZXIgZGlyIG1vdmVkIHRvIHVwcGVyIGxheWVyIHVuZGVyIHVzPyAqLworCQlp
ZiAoIWxvd2VyZGVudHJ5ICYmIG92bF9pbm9kZV9sb3dlcihpbm9kZSkpCisJCQlyZXR1cm4gZmFs
c2U7CisKKwkJLyogTG9va3VwIG9mIGFuIHVuY292ZXJlZCByZWRpcmVjdCBvcmlnaW4/ICovCisJ
CWlmICghdXBwZXJkZW50cnkgJiYgb3ZsX2lub2RlX3VwcGVyKGlub2RlKSkKKwkJCXJldHVybiBm
YWxzZTsKKwl9CisKIAkvKgogCSAqIEFsbG93IG5vbi1OVUxMIGxvd2VyIGlub2RlIGluIG92bF9p
bm9kZSBldmVuIGlmIGxvd2VyZGVudHJ5IGlzIE5VTEwuCiAJICogVGhpcyBoYXBwZW5zIHdoZW4g
ZmluZGluZyBhIGNvcGllZCB1cCBvdmVybGF5IGlub2RlIGZvciBhIHJlbmFtZWQKQEAgLTYwNiw2
ICs2MTYsOCBAQCBzdHJ1Y3QgaW5vZGUgKm92bF9nZXRfaW5vZGUoc3RydWN0IGRlbnRyeSAqZGVu
dHJ5LCBzdHJ1Y3QgZGVudHJ5ICp1cHBlcmRlbnRyeSwKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlOwog
CS8qIEFscmVhZHkgaW5kZXhlZCBvciBjb3VsZCBiZSBpbmRleGVkIG9uIGNvcHkgdXA/ICovCiAJ
Ym9vbCBpbmRleGVkID0gKGluZGV4IHx8IChvdmxfaW5kZXhkaXIoZGVudHJ5LT5kX3NiKSAmJiAh
dXBwZXJkZW50cnkpKTsKKwlzdHJ1Y3QgZGVudHJ5ICpvcmlnaW4gPSBpbmRleGVkID8gbG93ZXJk
ZW50cnkgOiBOVUxMOworCWJvb2wgaXNfZGlyOwogCiAJaWYgKFdBUk5fT04odXBwZXJkZW50cnkg
JiYgaW5kZXhlZCAmJiAhbG93ZXJkZW50cnkpKQogCQlyZXR1cm4gRVJSX1BUUigtRUlPKTsKQEAg
LTYxNCwxNSArNjI2LDE5IEBAIHN0cnVjdCBpbm9kZSAqb3ZsX2dldF9pbm9kZShzdHJ1Y3QgZGVu
dHJ5ICpkZW50cnksIHN0cnVjdCBkZW50cnkgKnVwcGVyZGVudHJ5LAogCQlyZWFsaW5vZGUgPSBk
X2lub2RlKGxvd2VyZGVudHJ5KTsKIAogCS8qCi0JICogQ29weSB1cCBvcmlnaW4gKGxvd2VyKSBt
YXkgZXhpc3QgZm9yIG5vbi1pbmRleGVkIHVwcGVyLCBidXQgd2UgbXVzdAotCSAqIG5vdCB1c2Ug
bG93ZXIgYXMgaGFzaCBrZXkgaW4gdGhhdCBjYXNlLgotCSAqIEhhc2ggaW5vZGVzIHRoYXQgYXJl
IG9yIGNvdWxkIGJlIGluZGV4ZWQgYnkgb3JpZ2luIGlub2RlIGFuZAotCSAqIG5vbi1pbmRleGVk
IHVwcGVyIGlub2RlcyB0aGF0IGNvdWxkIGJlIGhhcmQgbGlua2VkIGJ5IHVwcGVyIGlub2RlLgor
CSAqIENvcHkgdXAgb3JpZ2luIChsb3dlcikgbWF5IGV4aXN0IGZvciBub24taW5kZXhlZCBub24t
ZGlyIHVwcGVyLCBidXQKKwkgKiB3ZSBtdXN0IG5vdCB1c2UgbG93ZXIgYXMgaGFzaCBrZXkgaW4g
dGhhdCBjYXNlLgorCSAqIEhhc2ggbm9uLWRpciB0aGF0IGlzIG9yIGNvdWxkIGJlIGluZGV4ZWQg
Ynkgb3JpZ2luIGlub2RlLgorCSAqIEhhc2ggZGlyIHRoYXQgaXMgb3IgY291bGQgYmUgbWVyZ2Vk
IGJ5IG9yaWdpbiBpbm9kZS4KKwkgKiBIYXNoIHB1cmUgdXBwZXIgYW5kIG5vbi1pbmRleGVkIG5v
bi1kaXIgYnkgdXBwZXIgaW5vZGUuCiAJICovCi0JaWYgKCFTX0lTRElSKHJlYWxpbm9kZS0+aV9t
b2RlKSAmJiAodXBwZXJkZW50cnkgfHwgaW5kZXhlZCkpIHsKLQkJc3RydWN0IGlub2RlICprZXkg
PSBkX2lub2RlKGluZGV4ZWQgPyBsb3dlcmRlbnRyeSA6Ci0JCQkJCQkgICAgICB1cHBlcmRlbnRy
eSk7Ci0JCXVuc2lnbmVkIGludCBubGluazsKKwlpc19kaXIgPSBTX0lTRElSKHJlYWxpbm9kZS0+
aV9tb2RlKTsKKwlpZiAoaXNfZGlyKQorCQlvcmlnaW4gPSBsb3dlcmRlbnRyeTsKKworCWlmICh1
cHBlcmRlbnRyeSB8fCBvcmlnaW4pIHsKKwkJc3RydWN0IGlub2RlICprZXkgPSBkX2lub2RlKG9y
aWdpbiA/OiB1cHBlcmRlbnRyeSk7CisJCXVuc2lnbmVkIGludCBubGluayA9IGlzX2RpciA/IDEg
OiByZWFsaW5vZGUtPmlfbmxpbms7CiAKIAkJaW5vZGUgPSBpZ2V0NV9sb2NrZWQoZGVudHJ5LT5k
X3NiLCAodW5zaWduZWQgbG9uZykga2V5LAogCQkJCSAgICAgb3ZsX2lub2RlX3Rlc3QsIG92bF9p
bm9kZV9zZXQsIGtleSk7CkBAIC02NDMsOCArNjU5LDkgQEAgc3RydWN0IGlub2RlICpvdmxfZ2V0
X2lub2RlKHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgc3RydWN0IGRlbnRyeSAqdXBwZXJkZW50cnks
CiAJCQlnb3RvIG91dDsKIAkJfQogCi0JCW5saW5rID0gb3ZsX2dldF9ubGluayhsb3dlcmRlbnRy
eSwgdXBwZXJkZW50cnksCi0JCQkJICAgICAgcmVhbGlub2RlLT5pX25saW5rKTsKKwkJLyogUmVj
YWxjdWxhdGUgbmxpbmsgZm9yIG5vbi1kaXIgZHVlIHRvIGluZGV4aW5nICovCisJCWlmICghaXNf
ZGlyKQorCQkJbmxpbmsgPSBvdmxfZ2V0X25saW5rKGxvd2VyZGVudHJ5LCB1cHBlcmRlbnRyeSwg
bmxpbmspOwogCQlzZXRfbmxpbmsoaW5vZGUsIG5saW5rKTsKIAl9IGVsc2UgewogCQlpbm9kZSA9
IG5ld19pbm9kZShkZW50cnktPmRfc2IpOwpkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZzL3N1cGVy
LmMgYi9mcy9vdmVybGF5ZnMvc3VwZXIuYwppbmRleCBmNTczOGU5NmEwNTIuLmI4ZjhkNjY2ZThk
NCAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMKKysrIGIvZnMvb3ZlcmxheWZzL3N1
cGVyLmMKQEAgLTIwMCw2ICsyMDAsNyBAQCBzdGF0aWMgdm9pZCBvdmxfZGVzdHJveV9pbm9kZShz
dHJ1Y3QgaW5vZGUgKmlub2RlKQogCXN0cnVjdCBvdmxfaW5vZGUgKm9pID0gT1ZMX0koaW5vZGUp
OwogCiAJZHB1dChvaS0+X191cHBlcmRlbnRyeSk7CisJaXB1dChvaS0+bG93ZXIpOwogCWtmcmVl
KG9pLT5yZWRpcmVjdCk7CiAJb3ZsX2Rpcl9jYWNoZV9mcmVlKGlub2RlKTsKIAltdXRleF9kZXN0
cm95KCZvaS0+bG9jayk7CmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvdXRpbC5jIGIvZnMvb3Zl
cmxheWZzL3V0aWwuYwppbmRleCBiOWIyMzlmYTVjZmQuLmY2MGNlMmUwNGRmMCAxMDA2NDQKLS0t
IGEvZnMvb3ZlcmxheWZzL3V0aWwuYworKysgYi9mcy9vdmVybGF5ZnMvdXRpbC5jCkBAIC0yNTMs
NyArMjUzLDcgQEAgdm9pZCBvdmxfaW5vZGVfaW5pdChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1
Y3QgZGVudHJ5ICp1cHBlcmRlbnRyeSwKIAlpZiAodXBwZXJkZW50cnkpCiAJCU9WTF9JKGlub2Rl
KS0+X191cHBlcmRlbnRyeSA9IHVwcGVyZGVudHJ5OwogCWlmIChsb3dlcmRlbnRyeSkKLQkJT1ZM
X0koaW5vZGUpLT5sb3dlciA9IGRfaW5vZGUobG93ZXJkZW50cnkpOworCQlPVkxfSShpbm9kZSkt
Pmxvd2VyID0gaWdyYWIoZF9pbm9kZShsb3dlcmRlbnRyeSkpOwogCiAJb3ZsX2NvcHlhdHRyKGRf
aW5vZGUodXBwZXJkZW50cnkgPzogbG93ZXJkZW50cnkpLCBpbm9kZSk7CiB9CkBAIC0yNjksNyAr
MjY5LDcgQEAgdm9pZCBvdmxfaW5vZGVfdXBkYXRlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVj
dCBkZW50cnkgKnVwcGVyZGVudHJ5KQogCSAqLwogCXNtcF93bWIoKTsKIAlPVkxfSShpbm9kZSkt
Pl9fdXBwZXJkZW50cnkgPSB1cHBlcmRlbnRyeTsKLQlpZiAoIVNfSVNESVIodXBwZXJpbm9kZS0+
aV9tb2RlKSAmJiBpbm9kZV91bmhhc2hlZChpbm9kZSkpIHsKKwlpZiAoaW5vZGVfdW5oYXNoZWQo
aW5vZGUpKSB7CiAJCWlub2RlLT5pX3ByaXZhdGUgPSB1cHBlcmlub2RlOwogCQlfX2luc2VydF9p
bm9kZV9oYXNoKGlub2RlLCAodW5zaWduZWQgbG9uZykgdXBwZXJpbm9kZSk7CiAJfQotLSAKMi43
LjQKCg==
--94eb2c1882687396910565418416--
