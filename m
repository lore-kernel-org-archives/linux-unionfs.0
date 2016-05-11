From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs fixes for 4.6-rc7
Date: Wed, 11 May 2016 10:11:01 +0200
Message-ID: <CAJfpegtUzOmSdn49GosxUjxE5ZVYF10ViNx69zu2yfvW73SO2Q@mail.gmail.com>
References: <20160503200403.GB10623@veci.piliscsaba.szeredi.hu>
	<20160510152704.GK2694@ZenIV.linux.org.uk>
	<20160510202458.GD10623@veci.piliscsaba.szeredi.hu>
	<20160510232342.GE10623@veci.piliscsaba.szeredi.hu>
	<20160511040751.GO2694@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160511040751.GO2694@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, May 11, 2016 at 6:07 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, May 11, 2016 at 01:23:42AM +0200, Miklos Szeredi wrote:
>> Hi Al,
>>
>> Hopefully this addresses your concerns.  I couldn't find a better name for
>> lookup_hash(), after all it's just that.
>>
>> Please pull:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus
>>
>> ---
>> Miklos Szeredi (4):
>>       vfs: add vfs_select_inode() helper
>
> B0rken - for one thing, you've lost file->f_path = *path in vfs_open(), for
> another this thing belongs in dcache.h as static inline.  Fixed, pushed
> as vfs.git#ovl-fixes, merged into #for-linus.
>
> If you have any objections against the current state of that branch, please
> yell.

No objections.  Thanks for the fix.

Miklos
