MIME-Version: 1.0
Date: Fri, 1 Feb 2019 10:14:36 +0100
References: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
	<CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
	<CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
	<CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
	<CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
	<CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
	<CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
	<CAJfpegsVy=tep29H=zWhRYCVHBd4mYO=e_181DinZUQOaetoJA@mail.gmail.com>
	<CAOQ4uxha2VNZ-Da-w6U5yxrqA3PkixXPevk9_5NvMzg4-KkWSg@mail.gmail.com>
	<CAOQ4uxiKss89-J+Wv1q9QtvMMsypKFy-ktBom_Ss9kPr7_te6w@mail.gmail.com>
	<20190128192207.GA10240@redhat.com>
	<CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
	<CAJfpegth1vkgo67MbqfcmjXZLjxAW9mjoNaxLUW78iRtEqcaLQ@mail.gmail.com>
	<CAJfpegtay6O7S92eV0H=kV58E28z3Bmc4M0r6jYtoQkxSCjgUQ@mail.gmail.com>
	<CAOQ4uxhFSa-DAs4_7YQ0DB6yjE7Qr76Dm9TNs17L1wKAnEMy+g@mail.gmail.com>
	<CAJfpegsjfxTV44SbcKzV7T2U+BbOqgwLHgr7-jctqgUXxYzM_A@mail.gmail.com>
	<CAOQ4uxhnFeL-pHY6AM8UWD9RDu-RN=xuM-RCoq5Mw_htUvHBFA@mail.gmail.com>
	<CAJfpegv_GkeGapuTGDMtF79GL1iZK5+HA_p1+OQpqXhZsrS4JQ@mail.gmail.com>
	<CAOQ4uxgcCdpYoAbo5mp5AvdW9B-ENAJXgQbOtjsQoHKjr_b8iA@mail.gmail.com>
	<CAJfpegu_w+xfONCDMoqtLs=r6J8DUBjTU_W=pchRK0URum8c+Q@mail.gmail.com>
	<CAOQ4uxj08PhC2+h1LL+iKrAGnKXvT-oYNkFOjUqHrnBf84DswA@mail.gmail.com>
	<CAJfpegv1J4TvmhUvogGUP5pOZNT+gnRr1ygjWnyt7M56dirP0A@mail.gmail.com>
	<CAOQ4uxjh4yieJaacbP+5JbRY+=LV4oJU+1JCGV4S+eLE7FEcAw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjh4yieJaacbP+5JbRY+=LV4oJU+1JCGV4S+eLE7FEcAw@mail.gmail.com>
Message-ID: <CAJfpegu98HhOpajUOEm3OXXXTR4kePK-X3_hZurfDd=u0eHC0g@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: multipart/mixed; boundary="00000000000091896b0580d1924a"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

--00000000000091896b0580d1924a
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 31, 2019 at 10:54 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jan 31, 2019 at 6:24 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > There's some progress: it makes it through xfstests without crashing
> > or deadlocking.  There are still some regressing test cases, but
> > things definitely look better.
> >
>
> They do!
>
> kmemleak detected leaking ovl_readpage_work in ovl_readpage_work_fn()
> and creator_cred in ovl_direct_IO().
> I pushed your patch with the leak fixes to  ovl-aops-wip as a testing point.

Great, thanks for testing.

> > What remains is ctime/mtime support.
> >
> > Also fallocate/copyfile/reflink/etc will need some thought as we need
> > to not only flush out dirty pages, but in some cases prevent new
> > faults while the operation is in progress.
>
> Well, generic/503 which exercises these corners hangs
> (503.dmesg attached)

That was just a stupid bug in truncate (truncating ovl page with upper
inode lock held -> ABBA deadlock).

Attached the fix for that one.

> >
> > And after that it needs to be optimized (->readpages() and
> > ->writepages()), but I think that's the easy part.
> >
>
> And we also need to flush pages on non direct IO cases
> of ->writepages() and then we can revert:
> e8d4bfe3a715 ovl: Sync upper dirty data when syncing overlayfs
> and swoop the grand prize :)

Yeah.

I think the behavior should be tunable (ovl page cache vs. upper page
cache), at least initially, so it can be benchmarked in various
situations to see if there are no slowdowns with the new code.

Thanks,
Miklos

--00000000000091896b0580d1924a
Content-Type: text/x-patch; charset="US-ASCII"; name="d.patch"
Content-Disposition: attachment; filename="d.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jrltzsxy0
Content-ID: <f_jrltzsxy0>

ZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9maWxlLmMgYi9mcy9vdmVybGF5ZnMvZmlsZS5jCmlu
ZGV4IGFlY2QyODhmN2ZlMi4uZjk1NGYxNDI1MTg2IDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMv
ZmlsZS5jCisrKyBiL2ZzL292ZXJsYXlmcy9maWxlLmMKQEAgLTg1Myw3ICs4NTMsNyBAQCBzdGF0
aWMgaW50IG92bF9yZWFsX3JlYWRwYWdlKHN0cnVjdCBmaWxlICpyZWFsZmlsZSwgc3RydWN0IHBh
Z2UgKnBhZ2UpCiAKIAlpb3ZfaXRlcl9idmVjKCZpdGVyLCBSRUFELCAmYnZlYywgMSwgUEFHRV9T
SVpFKTsKIAotCXJldCA9IHZmc19pdGVyX3JlYWQocmVhbGZpbGUsICZpdGVyLCAmcG9zLCAwKTsK
KwlyZXQgPSB2ZnNfaXRlcl9yZWFkKHJlYWxmaWxlLCAmaXRlciwgJnBvcywgUldGX0RJUkVDVCk7
CiAJaWYgKHJldCA+PSAwICYmIHJldCA8IFBBR0VfU0laRSkKIAkJemVyb191c2VyX3NlZ21lbnQo
cGFnZSwgcmV0LCBQQUdFX1NJWkUpOwogCmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvaW5vZGUu
YyBiL2ZzL292ZXJsYXlmcy9pbm9kZS5jCmluZGV4IGUxMzlmOTJiNjRiYS4uZGFiY2M5MmRkMTc4
IDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMvaW5vZGUuYworKysgYi9mcy9vdmVybGF5ZnMvaW5v
ZGUuYwpAQCAtNzYsMTUgKzc2LDE1IEBAIGludCBvdmxfc2V0YXR0cihzdHJ1Y3QgZGVudHJ5ICpk
ZW50cnksIHN0cnVjdCBpYXR0ciAqYXR0cikKIAlvbGRfY3JlZCA9IG92bF9vdmVycmlkZV9jcmVk
cyhkZW50cnktPmRfc2IpOwogCWVyciA9IG5vdGlmeV9jaGFuZ2UodXBwZXJkZW50cnksIGF0dHIs
IE5VTEwpOwogCXJldmVydF9jcmVkcyhvbGRfY3JlZCk7Ci0JaWYgKCFlcnIpIHsKLQkJaWYgKGlz
X3RydW5jYXRlKQotCQkJdHJ1bmNhdGVfc2V0c2l6ZShpbm9kZSwgaV9zaXplX3JlYWQodXBwZXJp
bm9kZSkpOworCWlmICghZXJyKQogCQlvdmxfY29weWF0dHIodXBwZXJpbm9kZSwgaW5vZGUpOwot
CX0KIAlpbm9kZV91bmxvY2sodXBwZXJpbm9kZSk7CiAKLQlpZiAoaXNfdHJ1bmNhdGUpCisJaWYg
KGlzX3RydW5jYXRlKSB7CisJCWlmICghZXJyKQorCQkJdHJ1bmNhdGVfc2V0c2l6ZShpbm9kZSwg
aV9zaXplX3JlYWQodXBwZXJpbm9kZSkpOwogCQlwdXRfd3JpdGVfYWNjZXNzKHVwcGVyaW5vZGUp
OworCX0KIG91dF9kcm9wX3dyaXRlOgogCW92bF9kcm9wX3dyaXRlKGRlbnRyeSk7CiBvdXQ6Cg==
--00000000000091896b0580d1924a--
