From: Daniel Walsh <dwalsh@redhat.com>
Subject: Re: overlayfs access checks on underlying layers
Date: Thu, 29 Nov 2018 17:22:47 -0500
Message-ID: <f3a911a7-47eb-9922-a4be-25a834250e92@redhat.com>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com>
 <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com>
 <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov>
 <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov>
 <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
Reply-To: dwalsh@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 11/29/18 2:47 PM, Miklos Szeredi wrote:
> On Thu, Nov 29, 2018 at 5:14 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
>> Possibly I misunderstood you, but I don't think we want to copy-up on
>> permission denial, as that would still allow the mounter to read/write
>> special files or execute regular files to which it would normally be
>> denied access, because the copy would inherit the context specified by
>> the mounter in the context mount case.  It still represents an
>> escalation of privilege for the mounter.  In contrast, the copy-up on
>> write behavior does not allow the mounter to do anything it could not do
>> already (i.e. read from the lower, write to the upper).
> Let's get this straight:  when file is copied up, it inherits label
> from context=, not from label of lower file?

Yes, in the case of context mount, it will get the context mount directory.

In the case of not context mount, it should maintain the label of  the
lower.

>
> Next question: permission to change metadata is tied to permission to
> open?  Is it possible that open is denied, but metadata can be
> changed?
Yes, SElinux handles open differently then setattr.  Although I am not
sure if any tools handle this.
> DAC model allows this: metadata change is tied to ownership, not mode
> bits.   And different capability flag.
>
> If the same is true for MAC, then the pre-v4.20-rc1 is already
> susceptible to the privilege escalation you describe, right?
>
> Thanks,
> Miklos

After talking to Vivek, I am not sure their is a privilege escallation.


For device nodes, the mounter has to have the ability to create the
devicenode with the context mount, if he can do this, then he can do it
with or without Overlay.  This might lead to users making mistakes on
security, but the model is sound. And I think this stands even in the
case of the lower is mounted NODEV and the upper is not.  If the mounter
can create a device on the upper with a particular label, then he does
not need the lower.


For sockets, I see the case where a process is listening on the lower
level socket, the mounter mounts the overlay over the directory with the
socket.  Then the mounter changes the attributes of the socket,
performing a copy up.  If the mounter can not talk to the socket and the
other end is still listening, then this could be an issue.  If the
socket is no longer connected to the listener on the lower, then this is
not an issue.


Similar for a FIFO.


With SELinux we are also always checking not only the file access to the
socker, but also checking whether the label of the client is able to
talk to the label of the server daemon.  So we are protected by a
secondary check.
