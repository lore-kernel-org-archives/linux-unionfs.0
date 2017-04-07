From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs NFS export
Date: Fri, 7 Apr 2017 21:53:44 +0300
Message-ID: <CAOQ4uxgNsKrhveUqPntRJO2AOaf=c3ffN+djKUuxdTSNVqfLdA@mail.gmail.com>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
 <1491577054.10609.1.camel@primarydata.com> <CAJfpegu5hkHM7z4UWhoNhoXBJ9ZmmA8EpAaoThxRe45cCSDeAQ@mail.gmail.com>
 <CAOQ4uxgnvfZUdWfTsPMfjsvht9tEZi04GVyg=VzUNAWHyD=g_A@mail.gmail.com>
 <1491580705.12269.3.camel@primarydata.com> <CAOQ4uxg9MwAffRcwavhRJy+TO9LS=tNKmuy3QHyio5yHGJRN0A@mail.gmail.com>
 <1491583630.2745.23.camel@poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491583630.2745.23.camel@poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Trond Myklebust <trondmy@primarydata.com>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "bfields@fieldses.org" <bfields@fieldses.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Apr 7, 2017 at 7:47 PM, Jeff Layton <jlayton@poochiereds.net> wrote:
> On Fri, 2017-04-07 at 19:10 +0300, Amir Goldstein wrote:
>> On Fri, Apr 7, 2017 at 6:58 PM, Trond Myklebust <trondmy@primarydata.com> wrote:
>> > On Fri, 2017-04-07 at 18:45 +0300, Amir Goldstein wrote:
>> > > On Fri, Apr 7, 2017 at 6:28 PM, Miklos Szeredi <miklos@szeredi.hu>
...
>> > >
>> > > So why do we really need to find the upper in that case?
>> > > If we follow my idea, then NFS read request with lower handle
>> > > may be served from lower inode and NFS write request with a
>> > > lower handle will get ESTALE and will try to lookup by path
>> > > (I suppose?).
>> > >
>> >
>> > The client will never try to recover from an ESTALE error that is
>> > returned on a file it has already opened. That would cause data
>> > corruption if the user were to do something like 'rm foo; touch foo' on
>> > the server; writes that were intended for the old file would suddenly
>> > be written to the new one in violation of POSIX I/O rules.
>> >
>> >
>> > IOW: In the case where WRITE returns ESTALE, that error will result in
>> > the client returning EIO to the application on the next write() or
>> > fsync() or close(). That error will persist; a retry will not clear
>> > it.
>> >
>>
>> The most important point to understand is this:
>>
>> If server opens a file for write it will trigger a copy up
>> and the file handle returned will be persistent and final.
>>
>> The only problem is that when server opens a file for
>> read *before* it opens the same file for write, the returned
>> handle would be different, because first open for write
>> creates a new file and the old file remains a zombie
>> (as far as nfsd is concerned) only nfsd is able to to access
>> the old file and only for read.
>
> Once a copy-up occurs, then I expect it'd look to the client like the
> file had been renamed-over. You're getting back a different dentry/inode
> pair on lookup, right? Eventually the client will revalidate the parent
> directory inode, see that something has changed and redo the lookup for
> the thing. New opens would go to the copied-up inode after that point.
>

That is correct. And makes me wonder how bad applications over nfs
client behave in case of file having been renamed over? which seems
to be an equivalent case to copy up.

But it's time to look for real solutions and not try to work around them...

> In any case, nfsd will usually only hold the r/o file open if some
> client was holding that file open. So, it sounds like you'll end up
> projecting that weird overlayfs "read open before write open" corner
> case across the wire, but it would otherwise "work".
> --
> Jeff Layton <jlayton@poochiereds.net>
>
> [1] Side question: does the parent directory's mtime get updated when
> there is a copy-up? The client might not notice that its dentries are
> now invalid afterward unless it does.
>

Yes, because the parent directory is the upper directory where the
upper file gets copied to.

Thanks,
Amir.
