From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: fix uid/gid when creating over whiteout
Date: Wed, 15 Jun 2016 10:20:59 -0400
Message-ID: <20160615142059.GC19388@redhat.com>
References: <20160615133002.GA11993@veci.piliscsaba.szeredi.hu>
 <20160615140151.GB19388@redhat.com>
 <CAJfpegvopC3wA9YQ9J5khG3nCJ9zeXTpZ-SMj515vF5RMXEhNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegvopC3wA9YQ9J5khG3nCJ9zeXTpZ-SMj515vF5RMXEhNQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jun 15, 2016 at 04:09:47PM +0200, Miklos Szeredi wrote:
> On Wed, Jun 15, 2016 at 4:01 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Jun 15, 2016 at 03:30:02PM +0200, Miklos Szeredi wrote:
> 
> >> --- a/fs/overlayfs/dir.c
> >> +++ b/fs/overlayfs/dir.c
> >> @@ -405,12 +405,21 @@ static int ovl_create_or_link(struct den
> >>               err = ovl_create_upper(dentry, inode, &stat, link, hardlink);
> >>       } else {
> >>               const struct cred *old_cred;
> >> +             struct cred *override_cred;
> >>
> >>               old_cred = ovl_override_creds(dentry->d_sb);
> >>
> >> -             err = ovl_create_over_whiteout(dentry, inode, &stat, link,
> >> -                                            hardlink);
> >> +             err = -ENOMEM;
> >> +             override_cred = prepare_creds();
> >> +             if (override_cred) {
> >> +                     override_cred->fsuid = old_cred->fsuid;
> >> +                     override_cred->fsgid = old_cred->fsgid;
> >
> > Hi Miklos,
> >
> > I am wondering if we are switching to tasks's ->fsuid and ->fsgid too
> > early. ovl_create_over_whiteout() calls ovl_lookup_temp(workdir) and
> > IIUC, task might not have permission to do lookup in workdir.
> >
> > Should we switch to this override_cred, just before ovl_create_real()
> > so that task ->fsuid and ->fsgid are used only for creation purposes
> > only.
> 
> For lookup in workdir only CAP_DAC_OVERRIDE should matter, the actual
> value of the fsuid and fsgid should be irrelevant (user, group and
> others all have zero permission on workdir).

Ok. Agreed that CAP_DAC_OVERRIDE should do.

Thanks
Vivek
