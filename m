From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [RFC PATCH 0/5] allow unprivileged overlay mounts
Date: Tue, 29 Oct 2019 12:01:37 -0500
Message-ID: <20191029170137.GA21633@mail.hallyn.com>
References: <20191025112917.22518-1-mszeredi@redhat.com>
 <CAJfpegv1SA7b45_2g-GFYrc7ZsOmcQ2qv602n=85L4RknkOvKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegv1SA7b45_2g-GFYrc7ZsOmcQ2qv602n=85L4RknkOvKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 25, 2019 at 01:35:20PM +0200, Miklos Szeredi wrote:
> On Fri, Oct 25, 2019 at 1:30 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
> >
> > Hi Eric,
> >
> > Can you please have a look at this patchset?
> >
> > The most interesting one is the last oneliner adding FS_USERNS_MOUNT;
> > whether I'm correct in stating that this isn't going to introduce any
> > holes, or not...
> 
> Forgot the git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#ovl-unpriv
> 
> Thanks,
> Miklos

I've looked through it, seemed sensible to me.

-serge
