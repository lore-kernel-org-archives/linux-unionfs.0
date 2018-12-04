From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 4 Dec 2018 14:32:09 +0100
Message-ID: <CAJfpegtBDTMbmKd6eDxRmtSJjGN6CnpGK_QPNSsxjkOoeu=1pQ@mail.gmail.com>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com> <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com> <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov> <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov> <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
 <c993dba4-5129-7f04-2724-a82a1f1cafa3@tycho.nsa.gov> <f84bbe0b-f4c1-50e0-8c84-a6589154b3ae@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f84bbe0b-f4c1-50e0-8c84-a6589154b3ae@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 29, 2018 at 10:16 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
> On 11/29/18 4:03 PM, Stephen Smalley wrote:
> > On 11/29/18 2:47 PM, Miklos Szeredi wrote:
> >> On Thu, Nov 29, 2018 at 5:14 PM Stephen Smalley <sds@tycho.nsa.gov>
> >> wrote:
> >>
> >>> Possibly I misunderstood you, but I don't think we want to copy-up on
> >>> permission denial, as that would still allow the mounter to read/write
> >>> special files or execute regular files to which it would normally be
> >>> denied access, because the copy would inherit the context specified by
> >>> the mounter in the context mount case.  It still represents an
> >>> escalation of privilege for the mounter.  In contrast, the copy-up on
> >>> write behavior does not allow the mounter to do anything it could not do
> >>> already (i.e. read from the lower, write to the upper).
> >>
> >> Let's get this straight:  when file is copied up, it inherits label
> >> from context=, not from label of lower file?
> >
> > That's correct.  The overlay inodes are all assigned the label from the
> > context= mount option, and so are any upper inodes created through the
> > overlay.  At least that's my understanding of how it is supposed to
> > work.  The original use case was for containers with the lower dir
> > labeled with a context that is read-only to the container context and
> > using a context that is writable by the container context for the
> > context= mount.
> >
> >> Next question: permission to change metadata is tied to permission to
> >> open?  Is it possible that open is denied, but metadata can be
> >> changed?
> >
> > There is no metadata change occurring here. The overlay, upper, and
> > lower inodes all keep their labels intact for their lifetime (both
> > overlay and upper always have the context= label; upper has whatever its
>                                                    ^^lower^^
>
> > original label was), unless explicitly relabeled by some process.  And
> > when viewed through the overlay, the file always has the label specified
> > via context=, even before the copy-up.

Okay.

> >
> >> DAC model allows this: metadata change is tied to ownership, not mode
> >> bits.   And different capability flag.
> >>
> >> If the same is true for MAC, then the pre-v4.20-rc1 is already
> >> susceptible to the privilege escalation you describe, right?
> >
> > Actually, I guess there wouldn't be a privilege escalation if you
> > checked the mounter's ability to create the new file upon copy-up, and
> > checked the mounter's access to the upper inode label upon the
> > subsequent read, write, or execute access.  Then we'd typically block
> > the ability to create the device file and we'd block the ability to
> > execute files with the label from context=.
> >
> > But copy-up of special files seems undesirable for other reasons (e.g.
> > requiring mounters to be allowed to create device nodes just to permit
> > client's to read/write them, possible implications for nodev/noexec,
> > implications for socket and fifo files).

I think you missed my point: opening a device file or executing an
executable wouldn't normally require copy-up.   If

 -  permission is granted on overlay to task, and
 -  permission is granted on lower layer to mounter,

then copy-up wouldn't be performed.

My proposed sequence would be

a) check task's creds against overlay inode, fail -> return fail, otherwise:
b) check mounter's creds against lower inode, success -> return
success, otherwise:
c) copy up inode, fail -> return fail, otherwise
d) check mounter's creds against upper inode, return result.

So, unlike write access to regular files, write access to special
files don't necessarily result in copy-up.

You say this is an escalation of privilege, but I don't get it how.
As DWalsh points out downthread, if mounter cannot create device
files, then the copy-up will simply fail.  If mounter can create
device files, then this is not an escalation of privilege for the
mounter.

Thanks,
Miklos
