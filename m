From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 31/35] Revert "vfs: add d_real_inode() helper"
Date: Wed, 18 Apr 2018 09:56:07 -0400
Message-ID: <20180418095607.7acfc1bb@gandalf.local.home>
References: <20180412150826.20988-1-mszeredi@redhat.com>
        <20180412150826.20988-32-mszeredi@redhat.com>
        <CAOQ4uxgdWCWvwWgjUu06H=BeMxh-BVAjxVE5Ckj-poKRGgwvMQ@mail.gmail.com>
        <CAJfpegtLdmnxieDx7+FBUoc-fKsTEwA+oHinhAfa4E9SDFfSNw@mail.gmail.com>
        <20180418093845.19ca33f3@gandalf.local.home>
        <CAJfpeguJN0+m9Vhtv0fo79xq-P1UzWki9GqQq9WyJRMEwiJBqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpeguJN0+m9Vhtv0fo79xq-P1UzWki9GqQq9WyJRMEwiJBqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Howard McLauchlan <hmclauchlan@fb.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, 18 Apr 2018 15:49:02 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:


> > I just received this patch:
> >
> >  http://lkml.kernel.org/r/20180418062907.3210386-1-songliubraving@fb.com
> >
> > Which removes this code. Can you review it and I'll take it.  
> 
> It shouldn't remove d_real_inode(), because that part is correct and
> fixes a real bug in handling overlayfs files.
> 
> I'll review, but apparently I wasn't CC-d on that patch.   Weird.

Especially since you are on the "Reported-by".

My scripts know to add to the Cc "Reported-by" tags. Not all scripts do
though :-/

-- Steve
