From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ovl: set I_CREATING on inode being created
Date: Wed, 22 Aug 2018 13:14:51 -0700
Message-ID: <CA+55aFzMv5rkRJs2Xu4L3aAQM6UWSAFhHJhXECyquaW4+BXwBQ@mail.gmail.com>
References: <20180822085522.GA14354@veci.piliscsaba.redhat.com>
 <CA+55aFzd53LwrBfvdtKx7e_bQPhzsKEvCME1rGbrrY4pG94d=Q@mail.gmail.com> <CAJfpegsZUxZXQSHZoy0=9iqB6jRL0ZOtFGnSqT4FrzT8K2mcbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsZUxZXQSHZoy0=9iqB6jRL0ZOtFGnSqT4FrzT8K2mcbQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Aug 22, 2018 at 12:58 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > So I'd like some clarification on this point before applying it. It's
> > possible that the spinlock is required, I just want to understand why.
>
> I added the spinlock, because it's cheap (new_inode() already pulls it
> into L1 cache) and because it's much harder to prove that lockless one
> is correct than just adding that locking.

Ok, thanks, looks good to me. And looking around, I think it matches
most of the other cases of us setting those I_NEW and I_CREATING
flags, so I guess it's good from a consistency standpoint too.

I just wanted that clarified, but I'll just apply the patch directly.

Thanks,

             Linus
