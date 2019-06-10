Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190607010431.11868-1-mcoffin13@gmail.com> <20190607205105.21858-1-mcoffin13@gmail.com>
 <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com> <20190610183053.GA29869@redhat.com>
In-Reply-To: <20190610183053.GA29869@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 10 Jun 2019 21:51:45 +0300
Message-ID: <CAOQ4uxjf4nbPbAdbn3wGcJSKQJ7nTdHu_XpjM7zv5iW52G3M4g@mail.gmail.com>
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect defaults
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matt Coffin <mcoffin13@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jun 10, 2019 at 9:31 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sat, Jun 08, 2019 at 12:04:54PM +0300, Amir Goldstein wrote:
> > Hi Matt,
> >
> > Thank you for trying to address this, but I see problems both in Why and
> > How you did it.
> >
> > On Fri, Jun 7, 2019 at 11:51 PM Matt Coffin <mcoffin13@gmail.com> wrote:
> > >
> > > [Why]
> > > Currently, if the redirect_dir option is set as a kernel or module
> > > parameter, then even if metacopy is only enabled config, then both
> > > metacopy and redirect_dir will be enabled when one creates a mount
> > > point. This is not desirable because /sys/module/overlay/parameters will
> > > still report that redirect_dir is not enabled
> >
> > /sys/module/overlay/parameters reports that redirect_dir is not enabled
> > *by default* not per mount.
> >
> > > and there will be no redirect_dir=on line in the mount options in /proc/mounts.
> >
> > That is a bug. This code:
> > /* Automatically enable redirect otherwise. */
> > config->redirect_follow = config->redirect_dir = true;
> >
> > Needs to update of config->redirect_mode.
>
> Hi Amir,
>
> It took me a while to understand what's the problem. So IIUC, issue is
> that kernel has enabled redirect_dir by default. But it was disabled
> using module parameter. But it was enabled again as a side affect because
> metacopy=on was passed as mount option. And /proc/self/mountinfo does
> not show redirect_dir=on and hence the confusion.
>
> IIRC, once you mentioned that we only show those options which needs
> to be specified if same mount has to be reproduced on different machine
> with same kernel/module options. If yes, then setting
> config->redirect_dir=on is not needed because passing metacopy=on will
> ensure that.

I agree it is not a must fix bug, more of a nice to have.
In all other similar cases (actual differs from module param value) we would
have presented the option in /proc/mounts. It is only because redirect_dir is
not consistent with redirect_mode that we do not.
This seems inconsistent and hence I called it a bug.

Thanks,
Amir.
