From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 09/11] vfs: factor out inode_insert5()
Date: Mon, 11 Jun 2018 11:15:55 +0200
Message-ID: <CAJfpegt5guR3zJeATw4-N41Ad2n9pcB5mQoLmSLOfocnEoodVg@mail.gmail.com>
References: <20180529144143.16378-1-mszeredi@redhat.com> <20180529144143.16378-10-mszeredi@redhat.com>
 <20180610054902.GQ30522@ZenIV.linux.org.uk> <20180610060159.GS30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180610060159.GS30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 10, 2018 at 8:02 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jun 10, 2018 at 06:49:10AM +0100, Al Viro wrote:
>> On Tue, May 29, 2018 at 04:41:41PM +0200, Miklos Szeredi wrote:
>> > From: Miklos Szeredi <miklos@szeredi.hu>
>> >
>> > Split out common helper for race free insertion of an already allocated
>> > inode into the cache.  Use this from iget5_locked() and
>> > insert_inode_locked4().  Make iget5_locked() use new_inode()/iput() instead
>> > of alloc_inode()/destroy_inode() directly.
>>
>> ... thus hitting the sucker with ->evict_inode(), in condition that is quite
>> likely to be unfit to be seen by that.
>>
>> NAK.
>
> To clarify: objection here is against the switch to new_inode/iput.  The rest is
> sane.  What makes new_inode() better here, anyway?

Umm, got to look into this.  The patch has already been pulled by
Linus, but I hope it's salvageable.

Thanks,
Miklos
