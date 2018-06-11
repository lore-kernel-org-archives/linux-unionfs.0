From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 15/39] ovl: add helper to return real file
Date: Mon, 11 Jun 2018 10:11:42 +0200
Message-ID: <CAJfpegvoF=kMH1qx3nbegDAEcnSYQgGDiDOKxTiwq7rsR4hbog@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-16-mszeredi@redhat.com>
 <20180610054156.GP30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180610054156.GP30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 10, 2018 at 7:42 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, May 29, 2018 at 04:43:15PM +0200, Miklos Szeredi wrote:
>> In the common case we can just use the real file cached in
>> file->private_data.  There are two exceptions:
>>
>> 1) File has been copied up since open: in this unlikely corner case just
>> use a throwaway real file for the operation.  If ever this becomes a
>> perfomance problem (very unlikely, since overlayfs has been doing most fine
>> without correctly handling this case at all), then we can deal with that by
>> updating the cached real file.
>
> See the ovl_mmap() problem.  FWIW, I would probably suggest something along
> the lines of
>         ->private_data either points to struct file, or is 1 | address of
> 2-element array of struct file *
>         odd value => mask bit 0 away, cast to struct file ** and dereference
>         even value and it's still in the right layer => use that
>         even value and it is in the wrong layer =>
>                 allocate a two-pointer array
>                 open in the right layer
>                 stick that into array[0] and original - into array[1]
>                 cmpxchg array | 1 into ->private_data
>                 if that succeeds
>                         return array[0]
>                 else
>                         fput array[0], free array, then use the value returned
>                         by cmpxchg - mask bit 0 away, cast and dereference

Iff we really need that complexity, then yes, that's a nice solution.
But I think we don't:  see incremental posted for ->mmap() issue + for
plain I/O we don't really care about this case, since it happens so
rarely.  Maybe later...

Thanks,
Miklos
