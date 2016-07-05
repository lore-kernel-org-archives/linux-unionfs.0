From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] security, overlayfs: provide copy up security hook
 for unioned files
Date: Tue, 5 Jul 2016 17:52:30 -0400
Message-ID: <20160705215230.GI17987@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-2-git-send-email-vgoyal@redhat.com>
 <CAGH-Kgui7diECNuPahg-6_6q2T8HsyRvJERAO8xTcM0nYPQxiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496AbcGEVwc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 5 Jul 2016 17:52:32 -0400
Content-Disposition: inline
In-Reply-To: <CAGH-Kgui7diECNuPahg-6_6q2T8HsyRvJERAO8xTcM0nYPQxiQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Paul Moore <pmoore@redhat.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org

On Tue, Jul 05, 2016 at 05:35:22PM -0400, Paul Moore wrote:
> On Tue, Jul 5, 2016 at 11:50 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Provide a security hook to label new file correctly when a file is copied
> > up from lower layer to upper layer of a overlay/union mount.
> >
> > This hook can prepare and switch to a new set of creds which are suitable
> > for new file creation during copy up. Caller should revert to old creds
> > after file creation.
> >
> > In SELinux, newly copied up file gets same label as lower file for
> > non-context mounts. But it gets label specified in mount option context=
> > for context mounts.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c    |  8 ++++++++
> >  include/linux/lsm_hooks.h | 13 +++++++++++++
> >  include/linux/security.h  |  6 ++++++
> >  security/security.c       |  8 ++++++++
> >  security/selinux/hooks.c  | 27 +++++++++++++++++++++++++++
> >  5 files changed, 62 insertions(+)
> 
> ..
> 
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index a86d537..1b1a1e5 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -3270,6 +3270,32 @@ static void selinux_inode_getsecid(struct inode *inode, u32 *secid)
> >         *secid = isec->sid;
> >  }
> >
> > +static int selinux_inode_copy_up(struct dentry *src, const struct cred **old)
> > +{
> > +       u32 sid;
> > +       struct cred *new_creds;
> > +       struct task_security_struct *tsec;
> > +
> > +       new_creds = prepare_creds();
> > +       if (!new_creds)
> > +               return -ENOMEM;
> > +
> > +       /* Get label from overlay inode and set it in create_sid */
> > +       selinux_inode_getsecid(d_inode(src), &sid);
> > +       tsec = new_creds->security;
> > +       tsec->create_sid = sid;
> > +       *old = override_creds(new_creds);
> > +
> > +       /*
> > +        * At this point of time we have 2 refs on new_creds. One by
> > +        * prepare_creds and other by override_creds. Drop one reference
> > +        * so that as soon as caller calls revert_creds(old), this cred
> > +        * will be freed.
> > +        */
> > +       put_cred(new_creds);
> > +       return 0;
> > +}
> 
> One quick point of clarification: in addition to the SELinux specific
> comments in lsm_hooks.h, I think it would be a good idea if the
> SELinux hook implementation, e.g. security/selinux/hooks.c, was in its
> own patch and not part of the hook definition.

Ok, may be I will break every hook in three parts.

- lsm hook declaration.
- selinux implementation
- overlay implementation of call to hook.

> 
> Beyond that, I'm not overly excited about reusing create_sid for this
> purpose.  I understand why you did it, but what if the process had
> explicitly set create_sid?

When a file is copied up, either we retain the label of lower file or
set the new label from context=. If any create_sid is set in task, that's
ignored.

And as we are setting create_sid in a new set of credentials, task will
get to retain its create_sid for future operations.

As task does not know we are creating a new file, create_sid of task
should not matter at all. Task does not know if file is on upper or
file is being copied up. For task this file already exists, so task
should not expect create_sid label to be present.

Am I missing something.

Vivek

> I think I would prefer the creation of a
> new field (create_up_sid?) to track this new label and then add an
> additional check to selinux_inode_init_security() to prefer the
> existing create_sid to this new field when both are set.
> 
> Sound reasonable?
> 
> -- 
> paul moore
> security @ redhat
