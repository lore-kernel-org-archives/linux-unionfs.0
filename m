From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs access checks on underlying layers
Date: Thu, 29 Nov 2018 20:47:22 +0100
Message-ID: <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com> <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com> <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov> <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 29, 2018 at 5:14 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Possibly I misunderstood you, but I don't think we want to copy-up on
> permission denial, as that would still allow the mounter to read/write
> special files or execute regular files to which it would normally be
> denied access, because the copy would inherit the context specified by
> the mounter in the context mount case.  It still represents an
> escalation of privilege for the mounter.  In contrast, the copy-up on
> write behavior does not allow the mounter to do anything it could not do
> already (i.e. read from the lower, write to the upper).

Let's get this straight:  when file is copied up, it inherits label
from context=, not from label of lower file?

Next question: permission to change metadata is tied to permission to
open?  Is it possible that open is denied, but metadata can be
changed?

DAC model allows this: metadata change is tied to ownership, not mode
bits.   And different capability flag.

If the same is true for MAC, then the pre-v4.20-rc1 is already
susceptible to the privilege escalation you describe, right?

Thanks,
Miklos
