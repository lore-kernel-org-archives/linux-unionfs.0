From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 15/39] ovl: add helper to return real file
Date: Sun, 10 Jun 2018 06:42:04 +0100
Message-ID: <20180610054156.GP30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-16-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-16-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:15PM +0200, Miklos Szeredi wrote:
> In the common case we can just use the real file cached in
> file->private_data.  There are two exceptions:
> 
> 1) File has been copied up since open: in this unlikely corner case just
> use a throwaway real file for the operation.  If ever this becomes a
> perfomance problem (very unlikely, since overlayfs has been doing most fine
> without correctly handling this case at all), then we can deal with that by
> updating the cached real file.

See the ovl_mmap() problem.  FWIW, I would probably suggest something along
the lines of
	->private_data either points to struct file, or is 1 | address of
2-element array of struct file *
	odd value => mask bit 0 away, cast to struct file ** and dereference
	even value and it's still in the right layer => use that
	even value and it is in the wrong layer =>
		allocate a two-pointer array
		open in the right layer
		stick that into array[0] and original - into array[1]
		cmpxchg array | 1 into ->private_data
		if that succeeds
			return array[0]
		else
			fput array[0], free array, then use the value returned
			by cmpxchg - mask bit 0 away, cast and dereference
