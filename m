Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190423065024.12695-1-jencce.kernel@gmail.com>
 <CAOQ4uxgo-R8CUONFy=e6N8DfbeJb+AJmShJcDd9xgdy69BwZyA@mail.gmail.com>
 <CAJfpeguOMEoxk_CM-akuGQ8rc=K=HvHWVtYMxcUbx88_T-uDtA@mail.gmail.com>
 <CAOQ4uxgk-qkn0YdKP5rEvJvmzhhBUZzjPNqUVe6geXQ+xt9eiw@mail.gmail.com>
 <CAJfpegvwgJnuuAdaVK-TjQ=6_MBwf8zQNztPLcjOK5GpHbeCEA@mail.gmail.com>
 <CAOQ4uxhSbZaLHa9LZ9v6yzVkTof_D4mnCVREYOm=D0roF=nNNw@mail.gmail.com>
 <CAJfpegvDR7aVg-r+aGot+ATB04=NVg4LigV-1y1n=qHjSfOGvA@mail.gmail.com> <CAOQ4uxgEMkCPD0FU1VJsdYhWcNdO9wwistMGig8qHaekOiER+A@mail.gmail.com>
In-Reply-To: <CAOQ4uxgEMkCPD0FU1VJsdYhWcNdO9wwistMGig8qHaekOiER+A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Apr 2019 19:24:03 +0300
Message-ID: <CAOQ4uxgeoE6cQuEEu89TXQiwRop2hm7WhD=_mGvafXimkhzLSQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: add RWF_NONITIFY flag to skip wrong duplicate
 fanotify event
Content-Type: multipart/mixed; boundary="0000000000000d208b058735047d"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-unionfs@vger.kernel.org>

--0000000000000d208b058735047d
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 23, 2019 at 6:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Apr 23, 2019 at 5:16 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, Apr 23, 2019 at 3:53 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Apr 23, 2019 at 4:41 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Tue, Apr 23, 2019 at 2:44 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Tue, Apr 23, 2019 at 2:40 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > >
> > > > > > On Tue, Apr 23, 2019 at 1:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > >
> > > > > > > On Tue, Apr 23, 2019 at 9:51 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > > > > > > >
> > > > > > > > Overlays ovl_iter_write calls vfs_iter_write to write on real file,
> > > > > > > > in which calls fsnotify_modify on this change, however vfs_write also
> > > > > > > > calls fsnotify_modify after ovl_iter_write. The first notification
> > > > > > > > sent by vfs_iter_write grabs marks from upper inode and overlay mnt,
> > > > > > > > because of its fake path. The second one sent by vfs_write grabs marks
> > > > > > > > from ovl inode and ovl mnt.
> > > > > > > >
> > > > > > > > LTP fanotify06 add modify mark for mnt point, then add ignore modify
> > > > > > > > mask on testfile, then truncate and write the file. Because the ignore
> > > > > > > > mask is marked on ovl inode, not the upper inode, the first event is not
> > > > > > > > masked like the second one. So we get a modification event even with a
> > > > > > > > mask on the file.
> > > > > > >
> > > > > > > Care to extend fanotify06 in a similar manner to the way readahead02
> > > > > > > was extended to test overlay test case regardless of the base LTP filesystem?
> > > > > > >
> > > > > > > >
> > > > > > > > Proposing fixing this by add a new RWF flag to skip fsnotify on this IO.
> > > > > > > > vfs_iter_write used by ovl can use this flag to skip one duplicate event.
> > > > > > > >
> > > > > > >
> > > > > > > This fix is wrong for several reasons:
> > > > > > > - It exports RWF_NONOTIFY to uapi
> > > > > > > - It will cause no events at all when overlay writes to file even when user
> > > > > > > requested events on upper inode
> > > > > > >
> > > > > > > Please try attached patch.
> > > > > >
> > > > > > Would be nice, but until mmap stops using realfile this isn't a good solution.
> > > > > >
> > > > >
> > > > > Sigh! I figured there was a catch...
> > > > > Will it be ok if fake path used a cloned private mount of overlay mount?
> > > >
> > > > So the reason we have the fake path is e.g. /proc/$$/maps.  That can
> > > > only work with the original mount, AFAICS.
> > > >
> > > > We could have one realfile for regular I/O and a separate one for mmap
> > > > but that would increase complexity as well as resource use, so I'm not
> > > > quite sure if that's the right solution.
> > > >
> > >
> > > I see. Well what we could do is set a file flag for fake path, so at least
> > > fsnotify will be able to ignore f_path->mnt when calculating ignore mask.
> >
> > FMODE_NONOTIFY_MNT: like FMODE_NONOTIFY, but only affect mount marks?
> >
>
> On second thought I don't think there a need for an explicit
> FMODE_NONOTIFY_MNT/FMODE_FAKE_PATH flag because code
> can just check for file_inode(f) != d_inode(f->f_path->dentry).
> The question is what do do about this.
> I think situation is actually worse than reported (CC Jan).
>
> This problem existed even before stacked f_op, but is now manifesting
> differently because of stacked f_op.
>
> When user sets a mark on real inode or real parent dir inode, the
> user events that user gets when operations are performed via overlayfs file
> are with event->fd created by dentry_open(&event->path, ...
> So even when ignore mount marks are not involved, user will get the wrong
> path (overlayfs path) and referenced by event->fd while the mark was set
> on the real inode.
>
> The good new is that I believe fanotify marks are most commonly set on
> mount marks in the wild (?), so the events via overlayfs file on real inode
> won't be triggered in this case anyway and that's fine.
> FAN_MARK_FILESYSTEM may have opened up the possibility of exposing
> this bug to new users.
>
> In fsnotify_path(), when inode mismatches path->dentry->d_inode
> calling fsnotify_parent() is wrong (we are looking for parent watch of
> inode) and passing FSNOTIFY_EVENT_PATH info is wrong, because
> fsnotify() will filter by wrong mount and wrong path will we reported to
> user via event->fd.
>
> We could still report the event with FSNOTIFY_EVENT_INODE info,
> so at least inotify/audit watch on inode itself will work, but parent
> watches will not work as well as legacy fanotify inode watches.
> New FAN_REPORT_FID fanotify watches should work just fine.
>
> Any other ideas how to untangle?
>

How about this patch?

If prevents duplicate events due to "fake" path and addresses
the reported issue with ignore mask, but it leaves the "wrong"
paths reported with event->fd as is.

Murpphy, can you test it?

Thanks,
Amir.

--0000000000000d208b058735047d
Content-Type: text/plain; charset="US-ASCII";
	name="0001-fsnotify-do-not-generate-duplicate-fsnotify-events-f.patch.txt"
Content-Disposition: attachment;
	filename="0001-fsnotify-do-not-generate-duplicate-fsnotify-events-f.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_jutzz66a0>
X-Attachment-Id: f_jutzz66a0

RnJvbSAyY2M2ZmUxNjEzMGU0ODIxNzZkZTEwNWQ2ZjkwNmNmMDA0N2UyZGI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIzIEFwciAyMDE5IDE4OjI0OjEyICswMzAwClN1YmplY3Q6IFtQQVRDSF0gZnNu
b3RpZnk6IGRvIG5vdCBnZW5lcmF0ZSBkdXBsaWNhdGUgZnNub3RpZnkgZXZlbnRzIGZvcgogImZh
a2UiIHBhdGgKCk92ZXJsYXlmcyAiZmFrZSIgcGF0aCBpcyB1c2VkIGZvciBzdGFja2VkIGZpbGUg
b3BlcmF0aW9ucyBvbgp1bmRlcmx5aW5nIGZpbGVzLiAgT3BlcmF0aW9ucyBvbiBmaWxlcyB3aXRo
ICJmYWtlIiBwYXRoIG11c3Qgbm90CmdlbmVyYXRlIGV2ZW50cyBvbiBtb3VudCBtYXJrcyBhbmQg
b24gcGFyZW50IHdhdGNoZXMsIGJlY2F1c2UKdGhvc2UgZXZlbnRzIGhhdmUgYWxyZWFkeSBiZWVu
IGdlbmVyYXRlZCBhdCBvdmVybGF5ZnMgbGF5ZXIuCgpUaGUgcmVwb3J0ZWQgZXZlbnQtPmZkIGZv
ciBpbm9kZS9zYiBtYXJrcyB3aWxsIGhhdmUgdGhlIHdyb25nIHBhdGgKKG92ZXJsYXlmcyBwYXRo
KSwgYnV0IHdlIGhhdmUgbm8gY2hvaWNlIGJ1dCB0byByZXBvcnQgdGhlbSBhbnl3YXkuCgpMaW5r
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1mc2RldmVsLzIwMTkwNDIzMDY1MDI0LjEy
Njk1LTEtamVuY2NlLmtlcm5lbEBnbWFpbC5jb20vClJlcG9ydGVkLWJ5OiBNdXJwaHkgWmhvdSA8
amVuY2NlLmtlcm5lbEBnbWFpbC5jb20+CkZpeGVzOiBkMWQwNGVmODU3MmIgKCJvdmw6IHN0YWNr
IGZpbGUgb3BzIikKU2lnbmVkLW9mZi1ieTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWls
LmNvbT4KLS0tCiBmcy9ub3RpZnkvZnNub3RpZnkuYyAgICAgfCAxOCArKysrKysrKysrKysrKysr
LS0KIGluY2x1ZGUvbGludXgvZnNub3RpZnkuaCB8IDE0ICsrKysrKysrKysrLS0tCiAyIGZpbGVz
IGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvbm90aWZ5L2Zzbm90aWZ5LmMgYi9mcy9ub3RpZnkvZnNub3RpZnkuYwppbmRleCBkZjA2ZjNk
YTE2NmMuLmVlNWU0ZWE3ZTVjYSAxMDA2NDQKLS0tIGEvZnMvbm90aWZ5L2Zzbm90aWZ5LmMKKysr
IGIvZnMvbm90aWZ5L2Zzbm90aWZ5LmMKQEAgLTMzNSw5ICszMzUsMjMgQEAgaW50IGZzbm90aWZ5
KHN0cnVjdCBpbm9kZSAqdG9fdGVsbCwgX191MzIgbWFzaywgY29uc3Qgdm9pZCAqZGF0YSwgaW50
IGRhdGFfaXMsCiAJX191MzIgdGVzdF9tYXNrID0gKG1hc2sgJiBBTExfRlNOT1RJRllfRVZFTlRT
KTsKIAogCWlmIChkYXRhX2lzID09IEZTTk9USUZZX0VWRU5UX1BBVEgpIHsKLQkJbW50ID0gcmVh
bF9tb3VudCgoKGNvbnN0IHN0cnVjdCBwYXRoICopZGF0YSktPm1udCk7Ci0JCW1udF9vcl9zYl9t
YXNrIHw9IG1udC0+bW50X2Zzbm90aWZ5X21hc2s7CisJCWNvbnN0IHN0cnVjdCBwYXRoICpwYXRo
ID0gKGNvbnN0IHN0cnVjdCBwYXRoICopZGF0YTsKKworCQkvKgorCQkgKiBPdmVybGF5ZnMgImZh
a2UiIHBhdGggdXNlZCBmb3Igc3RhY2tlZCBmaWxlIG9wZXJhdGlvbnMgb24KKwkJICogdW5kZXJs
eWluZyBmaWxlcyBtdXN0IG5vdCBnZW5lcmF0ZSBldmVudHMgb24gbW91bnQgbWFya3MsCisJCSAq
IGJlY2F1c2UgdGhvc2UgZXZlbnRzIGhhdmUgYWxyZWFkeSBiZWVuIGdlbmVyYXRlZCBhdAorCQkg
KiBvdmVybGF5ZnMgbGF5ZXIuICBUaGUgcmVwb3J0ZWQgZXZlbnQtPmZkIGZvciBpbm9kZS9zYiBt
YXJrcworCQkgKiB3aWxsIGhhdmUgdGhlIHdyb25nIHBhdGggKG92ZXJsYXlmcyBwYXRoKSwgYnV0
IHdlIGhhdmUgbm8KKwkJICogY2hvaWNlIGJ1dCB0byByZXBvcnQgdGhlbSBhbnl3YXkuCisJCSAq
LworCQlpZiAobGlrZWx5KChtYXNrICYgRlNfRVZFTlRfT05fQ0hJTEQpIHx8CisJCSAgICB0b190
ZWxsID09IGRfaW5vZGUocGF0aC0+ZGVudHJ5KSkpIHsKKwkJCW1udCA9IHJlYWxfbW91bnQoKChj
b25zdCBzdHJ1Y3QgcGF0aCAqKWRhdGEpLT5tbnQpOworCQkJbW50X29yX3NiX21hc2sgfD0gbW50
LT5tbnRfZnNub3RpZnlfbWFzazsKKwkJfQogCX0KKwogCS8qIEFuIGV2ZW50ICJvbiBjaGlsZCIg
aXMgbm90IGludGVuZGVkIGZvciBhIG1vdW50L3NiIG1hcmsgKi8KIAlpZiAobWFzayAmIEZTX0VW
RU5UX09OX0NISUxEKQogCQltbnRfb3Jfc2JfbWFzayA9IDA7CmRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L2Zzbm90aWZ5LmggYi9pbmNsdWRlL2xpbnV4L2Zzbm90aWZ5LmgKaW5kZXggMDk1ODdl
Mjg2MGI1Li4yYTE5Nzc5OWMwNmQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvZnNub3RpZnku
aAorKysgYi9pbmNsdWRlL2xpbnV4L2Zzbm90aWZ5LmgKQEAgLTQ3LDEwICs0NywxOCBAQCBzdGF0
aWMgaW5saW5lIGludCBmc25vdGlmeV9wYXJlbnQoY29uc3Qgc3RydWN0IHBhdGggKnBhdGgsCiBz
dGF0aWMgaW5saW5lIGludCBmc25vdGlmeV9wYXRoKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGNvbnN0
IHN0cnVjdCBwYXRoICpwYXRoLAogCQkJCV9fdTMyIG1hc2spCiB7Ci0JaW50IHJldCA9IGZzbm90
aWZ5X3BhcmVudChwYXRoLCBOVUxMLCBtYXNrKTsKKwkvKgorCSAqIE92ZXJsYXlmcyAiZmFrZSIg
cGF0aCB1c2VkIGZvciBzdGFja2VkIGZpbGUgb3BlcmF0aW9ucyBvbiB1bmRlcmx5aW5nCisJICog
ZmlsZXMgbXVzdCBub3QgZ2VuZXJhdGUgZXZlbnRzIG9uIHBhcmVudCwgYmVjYXVzZSB0aG9zZSBl
dmVudHMgaGF2ZQorCSAqIGFscmVhZHkgYmVlbiBnZW5lcmF0ZWQgYXQgb3ZlcmxheWZzIGxheWVy
LgorCSAqLworCWlmIChsaWtlbHkoaW5vZGUgPT0gZF9pbm9kZShwYXRoLT5kZW50cnkpKSkgewor
CQlpbnQgcmV0ID0gZnNub3RpZnlfcGFyZW50KHBhdGgsIE5VTEwsIG1hc2spOworCisJCWlmIChy
ZXQpCisJCQlyZXR1cm4gcmV0OworCX0KIAotCWlmIChyZXQpCi0JCXJldHVybiByZXQ7CiAJcmV0
dXJuIGZzbm90aWZ5KGlub2RlLCBtYXNrLCBwYXRoLCBGU05PVElGWV9FVkVOVF9QQVRILCBOVUxM
LCAwKTsKIH0KIAotLSAKMi4xNy4xCgo=
--0000000000000d208b058735047d--
