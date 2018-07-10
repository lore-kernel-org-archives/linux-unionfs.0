From: Rafael David Tinoco <rafael.tinoco@linaro.org>
Subject: Re: FAILED: patch "[PATCH] ovl: hash non-dir by lower inode for
 fsnotify" failed to apply to 4.14-stable tree
Date: Tue, 10 Jul 2018 11:16:20 -0300
Message-ID: <CABdQkv_DrHxZkL5OSWRr3feHe84HtrHwt_Agx=wVF6YVk7e-RQ@mail.gmail.com>
References: <152086697777252@kroah.com> <CABdQkv8E4Ofv5MSX=U0wk1MZ5=szUSr54vshhn6X_wsB+tEz2g@mail.gmail.com>
 <20180705151810.GA11929@kroah.com> <CABdQkv_yJL5-DEr4D5D=VTvC7WTq292OCmZteccROHmTwTjY6g@mail.gmail.com>
 <20180705153051.GA13764@kroah.com> <CABdQkv9mUMF_ewvE2_7AUXpxoS2ZUcbnxo+iL3yF3FU-aVLkBQ@mail.gmail.com>
 <20180705155710.GA20455@kroah.com> <CABdQkv_8Zu2oQfNYaYpF=hCEfh8dtq4beHvtuys0j_HLhbB2eg@mail.gmail.com>
 <20180705163212.GA7993@kroah.com> <CAOQ4uxhZTEcAMUUzTNOj-2=4w2u5qkP_Hsz6j2Gi-OoRUeVemQ@mail.gmail.com>
 <20180710135506.GE1123@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180710135506.GE1123@kroah.com>
Sender: stable-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: amir73il@gmail.com, rafael.tinoco@linaro.org, stable@vger.kernel.org, mszeredi@redhat.com, linux-unionfs@vger.kernel.org, lkft-triage@lists.linaro.org, anders.roxell@linaro.org
List-Id: linux-unionfs@vger.kernel.org

> > >> There is also another bug:
> > >>
> > >> https://bugs.linaro.org/show_bug.cgi?id=3303.
> > >>
> > >> Fanotify faces a srcu dead-lock when userland stops responding to
> > >> events for this other case. Fix for that bug is a 35 patches patchset
> > >> (including the fix,  commit 9dd813c15b2c101, for the particular
> > >> issue).
> > >>
> > >> Question is, should I document things of this nature on this list also
> > >> ? Even if it is likely a no-go for the backports ? Just as information
> > >> ? Should I just bring the attention to the backport need (all patches)
> > >> and you decide ?
> > >
> > > Same as above, if you test them and they work, and they resolve a
> > > reported and testable bug, why wouldn't we apply them?
> > >
> >
> > So this is the story with overlayfs - besides NFS export in v4.16,
> > I don't think overlayfs got any new "features". Since the day it was
> > merged upstream (v3.18) it was all about fixing bugs and
> > "non-standard-behaviors":
> > https://github.com/amir73il/overlayfs/wiki/Overlayfs-non-standard-behavior
> >
> > Are those non-standard behaviors reported and testable bugs? yes
> > but they have been around for so long that applications may have
> > become dependent on the non-standard-behavior, so the "bug fixes"
> > are often introduced as "features" that are off by default and need to
> > be explicitly enabled by config/module/mount option (e.g. redirect_dir
> > added in v4.10).
> >
> > Now if you want to apply all the fixes to non-standard-behavior,
> > I am maintaining a 4.9.y backport branch with *everything*:
> > https://github.com/amir73il/linux/commits/overlayfs-4.9.y
> >
> > So this branch also includes the NFS export feature, but I suspect
> > it going to be hairy to apply $SUBJECT fix in question without applying
> > the NFS export patches.
> >
> > What does the new benevolent Greg have to say about this?
> > Would you consider taking all non-standard-behavior fixes to stable?
> > If you do, I can help with maintaining the stable overlayfs branches.
>
> I'd prefer to stick with as close-to-possible as what Linus's tree has.
> But for stuff like this, maybe it just makes sense to leave it all alone
> and if people want the newer "features" they need to move to a newer
> kernel, like they should be doing anyway.
>
> So for now, let's just leave it as-is, if anyone complains we can
> revisit and look at the patches that are needed for backporting.
>
> sound reasonable?
>

Greg,

As spoke in this thread last week, I have prepared a patchset for v4.9
tree for one of the bugs I mentioned
(https://bugs.linaro.org/show_bug.cgi?id=3303). This bug is related to
a dead-lock in kernel waiting for userland events (fanotify).

Short Summary of BUG:
https://bugs.linaro.org/show_bug.cgi?id=3303#c16

Full conclusion after kdump analysis:
https://bugs.linaro.org/show_bug.cgi?id=3303#c14

The patch list for resolution is:

** [35/35] 054c636e5c80 fsnotify: Move ->free_mark callback to fsnotify_ops
ok [34/35] 7b1293234084 fsnotify: Add group pointer in fsnotify_init_mark()
ok [33/35] ebb3b47e37a4 fsnotify: Drop inode_mark.c
ok [32/35] b1362edfe15b fsnotify: Remove fsnotify_find_{inode|vfsmount}_mark()
ok [31/35] 2e37c6ca8d76 fsnotify: Remove fsnotify_detach_group_marks()
ok [30/35] 18f2e0d3a436 fsnotify: Rename fsnotify_clear_marks_by_group_flags()
ok [29/35] 416bcdbcbbb4 fsnotify: Inline
fsnotify_clear_{inode|vfsmount}_mark_group()
ok [28/35] 8920d2734d9a fsnotify: Remove fsnotify_recalc_{inode|vfsmount}_mask()
ok [27/35] 66d2b81bcb92 fsnotify: Remove
fsnotify_set_mark_{,ignored_}mask_locked()
ok [26/35] 05f0e38724e8 fanotify: Release SRCU lock when waiting for
userspace response
ok [25/35] 9385a84d7e1f fsnotify: Pass fsnotify_iter_info into
handle_event handler
** [NEED ] 3cd5eca8d7a2 fsnotify: constify 'data' passed to ->handle_event()
ok [24/35] abc77577a669 fsnotify: Provide framework for dropping SRCU
lock in ->handle_event
ok [23/35] f09b04a03e02 fsnotify: Remove special handling of mark
destruction on group shutdown
ok [22/35] 6b3f05d24d35 fsnotify: Detach mark from object list when
last reference is dropped
ok [21/35] 11375145a70d fsnotify: Move queueing of mark for
destruction into fsnotify_put_mark()
ok [20/35] e7253760587e inotify: Do not drop mark reference under idr_lock
ok [19/35] 08991e83b728 fsnotify: Free fsnotify_mark_connector when
there is no mark attached
ok [18/35] 04662cab59fc fsnotify: Lock object list with connector lock
ok [17/35] 2629718dd26f fsnotify: Remove useless list deletion and comment
ok [16/35] 73cd3c33ab79 fsnotify: Avoid double locking in
fsnotify_detach_from_object()
ok [15/35] 8212a6097a72 fsnotify: Remove indirection from fsnotify_detach_mark()
ok [14/35] a03e2e4f0783 fsnotify: Determine lock in fsnotify_destroy_marks()
ok [13/35] f06fd9875945 fsnotify: Move locking into fsnotify_find_mark()
ok [12/35] a242677bb1e6 fsnotify: Move locking into fsnotify_recalc_mask()
ok [11/35] 0810b4f9f207 fsnotify: Move fsnotify_destroy_marks()
ok [10/35] 755b5bc681eb fsnotify: Remove indirection from mark list addition
ok [09/35] e911d8af87db fsnotify: Make fsnotify_mark_connector hold
inode reference
ok [08/35] 86ffe245c430 fsnotify: Move object pointer to fsnotify_mark_connector
ok [NEED ] be29d20f3f5d audit: Fix sleep in atomic
ok [NEED ] e3ba730702af fsnotify: Remove fsnotify_duplicate_mark()
** [07/35] 9dd813c15b2c fsnotify: Move mark list head from object into
dedicated structure -> THIS ONE
ok [06/35] c1f33073ac1b fsnotify: Update comments
ok [05/35] 43471d15df0e audit_tree: Use mark flags to check whether
mark is alive
ok [04/35] f410ff65548c audit: Abstract hash key handling
ok [03/35] c97476400d3b fanotify: Move recalculation of inode /
vfsmount mask under mark_mutex
ok [02/35] 25c829afbd74 inotify: Remove inode pointers from debug messages
ok [01/35] 5198adf649a0 fsnotify: Remove unnecessary tests when showing fdinfo

ok = cherry-pick (no changes needed)
** = backport
[NEED] = needed for original patchset to be cherry-picked

(Original patchset came from
https://www.spinics.net/lists/linux-fsdevel/msg109131.html and there
was 3 backports for positional changes and 3 patches to satisfy the
cherry-picks).

And it merges with no issues in stable v4.9 tree (as you can see in
https://bugs.linaro.org/show_bug.cgi?id=3303#c21). I can submit in a
thread in stable list if you are willing to move further.

As you can see, this patchset solves the issue:

BUG [unpatched] https://bugs.linaro.org/show_bug.cgi?id=3303#c18
SOLVED [patched] https://bugs.linaro.org/show_bug.cgi?id=3303#c19

And introduces NO regressions in LTP or KSELFTEST:

KSELFTEST: https://bugs.linaro.org/show_bug.cgi?id=3303#c23
LTP: https://bugs.linaro.org/show_bug.cgi?id=3303#c27

I think now we've reached the "It depends" phase =). Let me know if
you think this is good to be acceptable for v4.9. We can run full
round of tests (on all boards and x86/amd64) if you choose to pull
this, during stable review.

I can try same thing for v4.4 if it is worth.

Cheers o/

-Rafael
