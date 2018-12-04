From: Paul Moore <paul@paul-moore.com>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 4 Dec 2018 18:01:23 -0500
Message-ID: <CAHC9VhSh7NxLdiaJV+SFF64wnw8i2vm2hs3XpeyACGF=FHAH_Q@mail.gmail.com>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com> <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com> <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov> <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov> <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
 <f3a911a7-47eb-9922-a4be-25a834250e92@redhat.com> <CAHC9VhRcQdLRZoYi9g-MZzG8xPaNyFFX1nPppo7D93BTFQ6BZg@mail.gmail.com>
 <5b52869e-b979-dcf6-becf-a97b8ed33909@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5b52869e-b979-dcf6-becf-a97b8ed33909@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Dan Walsh <dwalsh@redhat.com>, miklos@szeredi.hu, vgoyal@redhat.com, omosnace@redhat.com, bfields@fieldses.org, salyzyn@android.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Dec 4, 2018 at 9:40 AM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On 12/3/18 6:27 PM, Paul Moore wrote:
> > On Thu, Nov 29, 2018 at 5:22 PM Daniel Walsh <dwalsh@redhat.com> wrote:
> >> On 11/29/18 2:47 PM, Miklos Szeredi wrote:
> >>> On Thu, Nov 29, 2018 at 5:14 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >>>
> >>>> Possibly I misunderstood you, but I don't think we want to copy-up on
> >>>> permission denial, as that would still allow the mounter to read/write
> >>>> special files or execute regular files to which it would normally be
> >>>> denied access, because the copy would inherit the context specified by
> >>>> the mounter in the context mount case.  It still represents an
> >>>> escalation of privilege for the mounter.  In contrast, the copy-up on
> >>>> write behavior does not allow the mounter to do anything it could not do
> >>>> already (i.e. read from the lower, write to the upper).
> >>> Let's get this straight:  when file is copied up, it inherits label
> >>> from context=, not from label of lower file?
> >>
> >> Yes, in the case of context mount, it will get the context mount directory.
> >>
> >> In the case of not context mount, it should maintain the label of  the
> >> lower.
> >>
> >>> Next question: permission to change metadata is tied to permission to
> >>> open?  Is it possible that open is denied, but metadata can be
> >>> changed?
> >>
> >> Yes, SElinux handles open differently then setattr.  Although I am not
> >> sure if any tools handle this.
> >>
> >>> DAC model allows this: metadata change is tied to ownership, not mode
> >>> bits.   And different capability flag.
> >>>
> >>> If the same is true for MAC, then the pre-v4.20-rc1 is already
> >>> susceptible to the privilege escalation you describe, right?
> >>
> >> After talking to Vivek, I am not sure their is a privilege escallation.
> >
> > More on this below, but this thread doesn't have me convinced, and we
> > are at -rc5 right now.  We need to come to some decision on this soon
> > because we are running out of time before v4.20 is released with this
> > code.
> >
> >> For device nodes, the mounter has to have the ability to create the
> >> devicenode with the context mount, if he can do this, then he can do it
> >> with or without Overlay.  This might lead to users making mistakes on
> >> security, but the model is sound. And I think this stands even in the
> >> case of the lower is mounted NODEV and the upper is not.  If the mounter
> >> can create a device on the upper with a particular label, then he does
> >> not need the lower.
> >
> > The problem I have when looking at the current code is that permission
> > is given, regardless of what is requested, for any special_file() on
> > an overlayfs mount.
> >
> > It also looks like the mounter's creds are used when checking
> > permissions regardless of the file has been copied up or not; I would
> > expect that the mounter's permissions would only used when checking
> > permissions against the lower inode, no?
>
> No, that's never been the model as far as I know.  mounter's permissions
> are checked to the underlying inode, whether upper or lower.  client's
> permissions are only checked to the overlay inode.  upper and lower are
> logically backing store - upper for writes and lower for reads from
> unmodified files.  Now, in theory, upper should always be labeled the
> same as overlay, so client check against overlay should already imply
> client access to upper, unless someone has manually relabeled upper
> outside of the overlay.

Okay, thanks for the clarification on the model.  This seems a little
odd at first, but I'm trying to convince myself that it makes sense.

-- 
paul moore
www.paul-moore.com
