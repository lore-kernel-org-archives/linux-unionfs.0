Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34389 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbfC2L4B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Mar 2019 07:56:01 -0400
Received: by mail-yb1-f194.google.com with SMTP id c2so746822ybn.1
        for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2019 04:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <CALsfCbd2UKVsC4k=da5x+joaBQk-phCizkyF0vXeMNOYDojWwQ@mail.gmail.com>
 <CAOQ4uxgEaMVF4kp4O8T=vY4zZSWfFYK2JmhwB4JSKhRVb-0KXw@mail.gmail.com>
 <CALsfCbeFZu7WW3_-jGGtFA5EtM3H-yJ2wKpxhVbuXwK6uyOysg@mail.gmail.com>
 <CAOQ4uxhd9OdACFu5nedo-zeGZutu2a=RQdSQtUb7TZwwpgkCjw@mail.gmail.com> <CALsfCbfdJJycdVeyO=O1Jh7jz9XL7sDqj3xFn2cC+fgzcnrVtA@mail.gmail.com>
In-Reply-To: <CALsfCbfdJJycdVeyO=O1Jh7jz9XL7sDqj3xFn2cC+fgzcnrVtA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 29 Mar 2019 14:55:49 +0300
Message-ID: <CAOQ4uxgXpMLGFfCVw9oP7o5APDgtkjqAOde6fuJMao4-0=Y0Zw@mail.gmail.com>
Subject: Re: [Help]Cannot read symbolic link(Invalid argument) in overlayfs
Content-Type: multipart/mixed; boundary="000000000000bef1db05853a5aba"
Sender: linux-unionfs-owner@vger.kernel.org
To: koishi komeiji <maykagura@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

--000000000000bef1db05853a5aba
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 29, 2019 at 10:02 AM koishi komeiji <maykagura@gmail.com> wrote:

>> I imagine that if you restart container or just drop caches problem
>> goes away?
>
> I try to drop caches, the problem goes away immediately.
> So I think the problem is about dentry and inode cache.
>
> # ls -l | grep invalid
> ls: cannot read symbolic link librmifm.so: Invalid argument
> ls: cannot read symbolic link libdrv_vlan.so: Invalid argument
> #
> # echo 2 > /proc/sys/vm/drop_caches
> #
> # ls -l | grep invalid
> #
>
>
>
>> Do you know if the symlink was just recently created or if it existed before
>> container has been started?
>
> The symlink in the image is ok. when the container start, the  symlink
> is decompressed from a cpio file.In this time ,it is still  ok. Just
> after some time, it break suddenly.
>
>

Koishi,

I have a theory, but it is not so easy to test.
I am not sure if you are able to compile and install a new overlayfs module.
Attached is un-tested patch to solve the speculated problem.

This problem should not exist in stable kernel >= v4.14, so if you
can update the host kernel that would be the best option for you.

The problem described in the patch was solved in upstream kernel by
commits:
09d8b586731b ovl: move __upperdentry to ovl_inode
31747eda41ef ovl: hash directory inodes for fsnotify

But those depend on many other changes, so cannot be easily
backported to kernel v4.9.

What I speculate that happens is:
1. Some ovl dentry holds a reference on upper dentry
2. upper dentry hold a ref on upper NON-symlink inode
3. overlay inode->i_private point to upper inode, but does not
    hold a refcount to upper inode
4. overlay inode is hashed by value of upper inode pointer
5. At some point, overlay dentry, upper dentry and upper inode
   are dropped, but overlay inode remains with elevated refcount
   (maybe by inotify) and hashed
6. A new lookup of the symlink allocates a new upper inode
    struct and reuses the address of NON-symlink free upper inode
7. ovl lookup finds the old ovl inode in cache by upper inode
    address, but the found overlay inode is not a symlink
8. The new ovl dentry is !d_is_symlink, although stat(2) will show
    i_mode from real inode that is a symlink
9. readlink(2) of ovl dentry will also fail with -EINVAL
10. open(2) on ovl dentry will not try to follow symlink and will
    eventually fail to open the symlink itself with -ELOOP

Thanks,
Amir.

--000000000000bef1db05853a5aba
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-ovl-grab-a-reference-on-real-inode.patch"
Content-Disposition: attachment;
	filename="0001-ovl-grab-a-reference-on-real-inode.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtu0ate50>
X-Attachment-Id: f_jtu0ate50

RnJvbSBlMTYzNTE2YmU5ZjFiODJmMDcwYjExNGI4NTJhMmQ2NTljNzU1ZmIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDI5IE1hciAyMDE5IDE0OjE2OjQyICswMzAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBncmFiIGEgcmVmZXJlbmNlIG9uIHJlYWwgaW5vZGUKClRoZSBvdmVybGF5IGlub2RlLT5pX3By
aXZhdGUgcG9pbnRlciByZWZlcmVuY2VzIHRoZSByZWFsIGlub2RlLgpOb3JtYWxseSwgdGhlIHJl
YWwgaW5vZGUgcmVmY291bnQgaXMgaGVsZCBieSB0aGUgb3ZlcmxheSByZWFsCmRlbnRyeSByZWZl
cmVuY2UuCgpIb3dldmVyLCBpZiBvdmVybGF5IGlub2RlIGlzIHBpbm5lZCwgZm9yIGV4YW1wbGUg
YnkgaW5vdGlmeSB3YXRjaAphbmQgY2FjaGVzIGFyZSBkcm9wcGVkLCB0aGUgb3ZlcmxheSBkZW50
cnkgZ29lcyBhd2F5IHdpdGggdGhlCmVsZXZhdGVkIHJlZmNvdW50cyBhbmQgdGhlbiBpbm9kZS0+
aV9wcml2YXRlIG1heSBiZSBsZWZ0IHdpdGggYQpkYW5nbGluZyByZWZlcmVjZS4KCklmIHNhaWQg
b3ZlcmxheSBpbm9kZSBpcyBhbHNvIHVwcGVyIGFuZCBoYXNoZWQgKGJ5IGRlYWQgcmVhbCBpbm9k
ZQpwb2ludGVyKSBhIG5ldyBsb29rdXAgd2l0aCBuZXcgcmVhbCBpbm9kZSB0aGF0IGhhcyB0aGUg
c2FtZSBhZGRyZXNzCmFzIG9sZCByZWFsIGlub2RlIG1heSBmaW5kIHRoZSBiYWQgb3ZlcmxheSBp
bm9kZSBpbiBjYWNoZS4KClNpZ25lZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBn
bWFpbC5jb20+Ci0tLQogZnMvb3ZlcmxheWZzL2lub2RlLmMgfCAgNSArKysrLQogZnMvb3Zlcmxh
eWZzL3N1cGVyLmMgfCAxMiArKysrKysrKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvaW5vZGUu
YyBiL2ZzL292ZXJsYXlmcy9pbm9kZS5jCmluZGV4IDE2ZjZkYjg4YzhlNS4uNzM0MjMwYTUyNDRl
IDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMvaW5vZGUuYworKysgYi9mcy9vdmVybGF5ZnMvaW5v
ZGUuYwpAQCAtNDE2LDcgKzQxNiwxMCBAQCBzdGF0aWMgaW50IG92bF9pbm9kZV90ZXN0KHN0cnVj
dCBpbm9kZSAqaW5vZGUsIHZvaWQgKmRhdGEpCiAKIHN0YXRpYyBpbnQgb3ZsX2lub2RlX3NldChz
dHJ1Y3QgaW5vZGUgKmlub2RlLCB2b2lkICpkYXRhKQogewotCWlub2RlLT5pX3ByaXZhdGUgPSAo
dm9pZCAqKSAoKCh1bnNpZ25lZCBsb25nKSBkYXRhKSB8IE9WTF9JU1VQUEVSX01BU0spOworCXN0
cnVjdCBpbm9kZSAqcmVhbGlub2RlID0gZGF0YTsKKworCWlub2RlLT5pX3ByaXZhdGUgPSAodm9p
ZCAqKSAoKCh1bnNpZ25lZCBsb25nKSBpZ3JhYihyZWFsaW5vZGUpKSB8CisJCQkgICBPVkxfSVNV
UFBFUl9NQVNLKTsKIAlyZXR1cm4gMDsKIH0KIApkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZzL3N1
cGVyLmMgYi9mcy9vdmVybGF5ZnMvc3VwZXIuYwppbmRleCBlN2M4YWM0MWUyODguLjc1NTAwOTI4
YmJhNiAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMKKysrIGIvZnMvb3ZlcmxheWZz
L3N1cGVyLmMKQEAgLTE0OCw3ICsxNDgsNyBAQCBzdHJ1Y3QgZGVudHJ5ICpvdmxfZGVudHJ5X3Jl
YWwoc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogc3RhdGljIHZvaWQgb3ZsX2lub2RlX2luaXQoc3Ry
dWN0IGlub2RlICppbm9kZSwgc3RydWN0IGlub2RlICpyZWFsaW5vZGUsCiAJCQkgICBib29sIGlz
X3VwcGVyKQogewotCVdSSVRFX09OQ0UoaW5vZGUtPmlfcHJpdmF0ZSwgKHVuc2lnbmVkIGxvbmcp
IHJlYWxpbm9kZSB8CisJV1JJVEVfT05DRShpbm9kZS0+aV9wcml2YXRlLCAodW5zaWduZWQgbG9u
ZykgaWdyYWIocmVhbGlub2RlKSB8CiAJCSAgIChpc191cHBlciA/IE9WTF9JU1VQUEVSX01BU0sg
OiAwKSk7CiB9CiAKQEAgLTIzNCw3ICsyMzQsNyBAQCB2b2lkIG92bF9pbm9kZV91cGRhdGUoc3Ry
dWN0IGlub2RlICppbm9kZSwgc3RydWN0IGlub2RlICp1cHBlcmlub2RlKQogCVdBUk5fT04oIXVw
cGVyaW5vZGUpOwogCVdBUk5fT04oIWlub2RlX3VuaGFzaGVkKGlub2RlKSk7CiAJV1JJVEVfT05D
RShpbm9kZS0+aV9wcml2YXRlLAotCQkgICAodW5zaWduZWQgbG9uZykgdXBwZXJpbm9kZSB8IE9W
TF9JU1VQUEVSX01BU0spOworCQkgICAodW5zaWduZWQgbG9uZykgaWdyYWIodXBwZXJpbm9kZSkg
fCBPVkxfSVNVUFBFUl9NQVNLKTsKIAlpZiAoIVNfSVNESVIodXBwZXJpbm9kZS0+aV9tb2RlKSkK
IAkJX19pbnNlcnRfaW5vZGVfaGFzaChpbm9kZSwgKHVuc2lnbmVkIGxvbmcpIHVwcGVyaW5vZGUp
OwogfQpAQCAtNjg3LDEyICs2ODcsMTggQEAgc3RhdGljIGludCBvdmxfcmVtb3VudChzdHJ1Y3Qg
c3VwZXJfYmxvY2sgKnNiLCBpbnQgKmZsYWdzLCBjaGFyICpkYXRhKQogCXJldHVybiAwOwogfQog
CitzdGF0aWMgaW50IG92bF9kcm9wX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUpCit7CisJaXB1
dChvdmxfaW5vZGVfcmVhbChpbm9kZSkpOworCXJldHVybiAxOworfQorCiBzdGF0aWMgY29uc3Qg
c3RydWN0IHN1cGVyX29wZXJhdGlvbnMgb3ZsX3N1cGVyX29wZXJhdGlvbnMgPSB7CiAJLnB1dF9z
dXBlcgk9IG92bF9wdXRfc3VwZXIsCiAJLnN0YXRmcwkJPSBvdmxfc3RhdGZzLAogCS5zaG93X29w
dGlvbnMJPSBvdmxfc2hvd19vcHRpb25zLAogCS5yZW1vdW50X2ZzCT0gb3ZsX3JlbW91bnQsCi0J
LmRyb3BfaW5vZGUJPSBnZW5lcmljX2RlbGV0ZV9pbm9kZSwKKwkuZHJvcF9pbm9kZQk9IG92bF9k
cm9wX2lub2RlLAogfTsKIAogZW51bSB7Ci0tIAoyLjcuNAoK
--000000000000bef1db05853a5aba--
