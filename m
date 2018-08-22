From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ovl: set I_CREATING on inode being created
Date: Wed, 22 Aug 2018 07:53:08 -0700
Message-ID: <CA+55aFzd53LwrBfvdtKx7e_bQPhzsKEvCME1rGbrrY4pG94d=Q@mail.gmail.com>
References: <20180822085522.GA14354@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180822085522.GA14354@veci.piliscsaba.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Aug 22, 2018 at 1:55 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> +       spin_lock(&inode->i_lock);
> +       inode->i_state |= I_CREATING;
> +       spin_unlock(&inode->i_lock);
> +

Why is that spinlock protection there?

Isn't this a new inode that cannot possibly be reached any other way yet?

NOTE! This is a question. Maybe there is something I missed, and there
*are* other ways to reach that inode. But if that's true, isn't it
already too late to set I_CREATING?

So I'd like some clarification on this point before applying it. It's
possible that the spinlock is required, I just want to understand why.

          Linus
