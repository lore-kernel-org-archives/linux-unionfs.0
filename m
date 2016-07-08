From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] security, overlayfs: provide copy up security hook
 for unioned files
Date: Fri, 8 Jul 2016 08:45:34 -0400
Message-ID: <20160708124534.GA7732@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-2-git-send-email-vgoyal@redhat.com>
 <63906f0e-25cf-266b-6df9-18317f1e7c59@schaufler-ca.com>
 <20160707203329.GD11036@redhat.com>
 <2e7462e4-c84b-a6cf-74d3-35bf68048a61@schaufler-ca.com>
 <CAJfpegvQ8-fhdV-emzwhZX90k_Ray9imQTp0Cg5y+zRu3OAH3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbcGHMpg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 8 Jul 2016 08:45:36 -0400
Content-Disposition: inline
In-Reply-To: <CAJfpegvQ8-fhdV-emzwhZX90k_Ray9imQTp0Cg5y+zRu3OAH3A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>, David Howells <dhowells@redhat.com>, pmoore@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org

On Fri, Jul 08, 2016 at 09:21:13AM +0200, Miklos Szeredi wrote:
> On Thu, Jul 7, 2016 at 11:44 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> > On 7/7/2016 1:33 PM, Vivek Goyal wrote:
> >> On Tue, Jul 05, 2016 at 12:36:17PM -0700, Casey Schaufler wrote:
> >>> On 7/5/2016 8:50 AM, Vivek Goyal wrote:
> >>>> Provide a security hook to label new file correctly when a file is copied
> >>>> up from lower layer to upper layer of a overlay/union mount.
> >>>>
> >>>> This hook can prepare and switch to a new set of creds which are suitable
> >>>> for new file creation during copy up. Caller should revert to old creds
> >>>> after file creation.
> >>>>
> >>>> In SELinux, newly copied up file gets same label as lower file for
> >>>> non-context mounts. But it gets label specified in mount option context=
> >>>> for context mounts.
> >>>>
> >>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >>>> ---
> >>>>  fs/overlayfs/copy_up.c    |  8 ++++++++
> >>>>  include/linux/lsm_hooks.h | 13 +++++++++++++
> >>>>  include/linux/security.h  |  6 ++++++
> >>>>  security/security.c       |  8 ++++++++
> >>>>  security/selinux/hooks.c  | 27 +++++++++++++++++++++++++++
> >>>>  5 files changed, 62 insertions(+)
> >>>>
> >>>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> >>>> index 80aa6f1..90dc362 100644
> >>>> --- a/fs/overlayfs/copy_up.c
> >>>> +++ b/fs/overlayfs/copy_up.c
> >>>> @@ -246,6 +246,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >>>>     struct dentry *upper = NULL;
> >>>>     umode_t mode = stat->mode;
> >>>>     int err;
> >>>> +   const struct cred *old_creds = NULL;
> >>>>
> >>>>     newdentry = ovl_lookup_temp(workdir, dentry);
> >>>>     err = PTR_ERR(newdentry);
> >>>> @@ -258,10 +259,17 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >>>>     if (IS_ERR(upper))
> >>>>             goto out1;
> >>>>
> >>>> +   err = security_inode_copy_up(dentry, &old_creds);
> >>>> +   if (err < 0)
> >>>> +           goto out2;
> >>>> +
> >>>>     /* Can't properly set mode on creation because of the umask */
> >>>>     stat->mode &= S_IFMT;
> >>>>     err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
> >>>>     stat->mode = mode;
> >>>> +   if (old_creds)
> >>>> +           revert_creds(old_creds);
> >>>> +
> >>>>     if (err)
> >>>>             goto out2;
> >>> I don't much care for the way part of the credential manipulation
> >>> is done in the caller and part is done the the security module.
> >>> If the caller is going to restore the old state, the caller should
> >>> save the old state.
> 
> Conversely if the SM is setting the state it should restore it.
> This needs yet another hook, but that's fine, I think.
> 
> >> One advantage of current patches is that we switch to new creds only if
> >> it is needed. For example, if there are no LSMs loaded,
> >
> > Point.
> >
> >>  then there is
> >> no need to modify creds and make a switch to new creds.
> >
> > I'm not a fan of cred flipping. There are too many ways for it to go
> > wrong. Consider interrupts. I assume you've ruled that out as a possibility
> > in the caller, but I still think the practice is dangerous.
> >
> > I greatly prefer "create and set attributes" to "change cred, create and
> > reset cred". I know that has it's own set of problems, including races
> > and faking privilege.
> 
> Yeah, we've talked about this. The races can be eliminated by always
> doing the create in a the temporary "workdir" area and atomically
> renaming to the final destination after everything has been set up.
> OTOH that has a performance impact that the cred flipping eliminates.
> 
> >> But if I start allocating new creds and save old state in caller, then
> >> caller always has to do it (irrespective of the fact whether any LSM
> >> modified the creds or not).
> >
> > It starts getting messy when I have two modules that want to
> > change change the credential. Each module will have to check to
> > see if a module called before it has allocated a new cred.
> 
> Doesn't seem to me too difficult: check if *credp == NULL and allocate
> if so.  Can even invent a heper for this if needed.

Right. I like this approach. So cred allocation happens in LSM and
switching to new creds and freeing of new creds is done by caller.

That way, if no new creds are allocated, then caller does not have to
switch creds. Also all LSMs can work on single copy of newly allocated
cred and modify it. Also all LSMs can check if creds have already been
allocated otherwise allocate new one.

Thanks
Vivek
