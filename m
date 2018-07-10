From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: FAILED: patch "[PATCH] ovl: hash non-dir by lower inode for
 fsnotify" failed to apply to 4.14-stable tree
Date: Tue, 10 Jul 2018 15:55:06 +0200
Message-ID: <20180710135506.GE1123@kroah.com>
References: <152086697777252@kroah.com>
 <CABdQkv8E4Ofv5MSX=U0wk1MZ5=szUSr54vshhn6X_wsB+tEz2g@mail.gmail.com>
 <20180705151810.GA11929@kroah.com>
 <CABdQkv_yJL5-DEr4D5D=VTvC7WTq292OCmZteccROHmTwTjY6g@mail.gmail.com>
 <20180705153051.GA13764@kroah.com>
 <CABdQkv9mUMF_ewvE2_7AUXpxoS2ZUcbnxo+iL3yF3FU-aVLkBQ@mail.gmail.com>
 <20180705155710.GA20455@kroah.com>
 <CABdQkv_8Zu2oQfNYaYpF=hCEfh8dtq4beHvtuys0j_HLhbB2eg@mail.gmail.com>
 <20180705163212.GA7993@kroah.com>
 <CAOQ4uxhZTEcAMUUzTNOj-2=4w2u5qkP_Hsz6j2Gi-OoRUeVemQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhZTEcAMUUzTNOj-2=4w2u5qkP_Hsz6j2Gi-OoRUeVemQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Rafael David Tinoco <rafael.tinoco@linaro.org>, stable <stable@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jul 05, 2018 at 09:28:56PM +0300, Amir Goldstein wrote:
> On Thu, Jul 5, 2018 at 7:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jul 05, 2018 at 01:15:43PM -0300, Rafael David Tinoco wrote:
> >> > > commit 764baba80168ad3adafb521d2ab483ccbc49e344
> >> > > Author: Amir Goldstein <amir73il@gmail.com>
> >> > > Date:   Sun Feb 4 15:35:09 2018 +0200
> >> > >
> >> > >     ovl: hash non-dir by lower inode for fsnotify
> >> > >
> >> > > INFO: inotify issue with non-dir non-upper files in overlayfs exists
> >> > > in LTS <= v4.14.
> >> > > INFO: LTP inotify08 test fails on * v4.14 and bellow * and should be skipped.
> >> > >
> >> > > And message was informative only (clearly didn't work). Either way, do
> >> > > you think it's worth informing existing LTS bugs, found by test
> >> > > tooling, here ?
> >> >
> >> > Why can't we fix those bugs in the stable kernel releases?  Is it too
> >> > difficult to do so?
> >>
> >> For this inotify bug:
> >>
> >> Commits
> >>
> >>  ovl: hash non-dir by lower inode for fsnotify
> >>  ovl: hash non-indexed dir by upper inode for NFS export
> >>  ovl: do not pass overlay dentry to ovl_get_inode()
> >>  ovl: hash directory inodes for fsnotify
> >>  ovl: no direct iteration for dir with origin xattr
> >>  Revert "ovl: hash directory inodes for fsnotify"
> >>
> >> are needed AND all the logic for setting up "origin" variable in
> >> ovl_lookup, passed to ovl_lookup_index() after it got its prototype
> >> changed, would still be missing (and other refactoring changes,
> >> commits splitting functions and so on).
> >>
> >> So I assumed it was a no-go.
> >
> > It all depends, let's get the git commit ids for these please.  And have
> > you successfully applied and tested that those patches fix the issue?
> > If so, great, let's apply them!
> >
> >> There is also another bug:
> >>
> >> https://bugs.linaro.org/show_bug.cgi?id=3303.
> >>
> >> Fanotify faces a srcu dead-lock when userland stops responding to
> >> events for this other case. Fix for that bug is a 35 patches patchset
> >> (including the fix,  commit 9dd813c15b2c101, for the particular
> >> issue).
> >>
> >> Question is, should I document things of this nature on this list also
> >> ? Even if it is likely a no-go for the backports ? Just as information
> >> ? Should I just bring the attention to the backport need (all patches)
> >> and you decide ?
> >
> > Same as above, if you test them and they work, and they resolve a
> > reported and testable bug, why wouldn't we apply them?
> >
> 
> So this is the story with overlayfs - besides NFS export in v4.16,
> I don't think overlayfs got any new "features". Since the day it was
> merged upstream (v3.18) it was all about fixing bugs and
> "non-standard-behaviors":
> https://github.com/amir73il/overlayfs/wiki/Overlayfs-non-standard-behavior
> 
> Are those non-standard behaviors reported and testable bugs? yes
> but they have been around for so long that applications may have
> become dependent on the non-standard-behavior, so the "bug fixes"
> are often introduced as "features" that are off by default and need to
> be explicitly enabled by config/module/mount option (e.g. redirect_dir
> added in v4.10).
> 
> Now if you want to apply all the fixes to non-standard-behavior,
> I am maintaining a 4.9.y backport branch with *everything*:
> https://github.com/amir73il/linux/commits/overlayfs-4.9.y
> 
> So this branch also includes the NFS export feature, but I suspect
> it going to be hairy to apply $SUBJECT fix in question without applying
> the NFS export patches.
> 
> What does the new benevolent Greg have to say about this?
> Would you consider taking all non-standard-behavior fixes to stable?
> If you do, I can help with maintaining the stable overlayfs branches.

I'd prefer to stick with as close-to-possible as what Linus's tree has.
But for stuff like this, maybe it just makes sense to leave it all alone
and if people want the newer "features" they need to move to a newer
kernel, like they should be doing anyway.

So for now, let's just leave it as-is, if anyone complains we can
revisit and look at the patches that are needed for backporting.

sound reasonable?

thanks,

greg k-h
