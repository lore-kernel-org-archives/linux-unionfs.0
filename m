From: Eiichi Tsukata <devel@etsukata.com>
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek
	SEEK_END and write
Date: Mon, 26 Nov 2018 11:54:06 +0900
Message-ID: <CANhTXPSsh8mdedkm6wVAAQXk3wY7J2aSdgojZGxFR+ctArBsJw@mail.gmail.com>
References: <20181121024400.4346-1-devel@etsukata.com>
	<20181121045440.GM32577@ZenIV.linux.org.uk>
	<CANhTXPQzKmsyPO9QrGz6eijjuMFzLN4BhUV=6ABDJysX0xyKfw@mail.gmail.com>
	<20181122070650.GN32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20181122070650.GN32577@ZenIV.linux.org.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, Chris Mason <clm@fb.com>, andi@firstfloor.org, Andreas Dilger <adilger.kernel@dilger.ca>, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

2018年11月22日(木) 16:06 Al Viro <viro@zeniv.linux.org.uk>:
>
> Can you show me where does POSIX/SuS/whatever it's called these days promise
> that kind of atomicity?

No. I couldn't found it.
That's why I previously posted RFC Patch:
https://marc.info/?t=154237277900001&r=1&w=2
I wasn't sure this is a bug in the kernel or not.

> that kind of atomicity?  TBH, I would be very surprised if any Unix promised
> to have file size updated no more than once per write(2).  Any userland code
> that relies on such property is, as minimum, non-portable and I would argue
> that it is outright broken.

Thanks. Now It's clear. It is not a bug in the kernel, but in
userspace if `tail` assumes such
atomicity.

> Note, BTW, that your example depends upon rather non-obvious details of echo
> implementation, starting with the bufferization logics used by particular
> shell.  And AFAICS ash(1) ends up with possibility of more than one write(2)

I've never imagined such a difference in echo implementation, thanks.
