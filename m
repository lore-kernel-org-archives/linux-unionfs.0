MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiALH82=9Q4y1DNO1_-LmKy4WPpevypKndcFw-ATtNkRg@mail.gmail.com>
References: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
	<CAJfpegsQ01V9Jyboy+9W9eahMDNM7nggLHFkbD=13hNhX+Du0g@mail.gmail.com>
	<CAOQ4uxg=aQpHWFEz4M+Kz9gOtu6XJd8rGw1oa4zrtyMZ+T7ogQ@mail.gmail.com>
	<CAJfpegsKYh5hWofQxO5gVCLL3PoAGSaVEF8O+K72tk+TBjEJwQ@mail.gmail.com>
	<CAOQ4uxhQku0jchmxynrQ2CXunSnDuWppaK3d2e41+txzsJQPzQ@mail.gmail.com>
	<CAJfpegv3AFBR6J1Bd9tSw0KrahC33W6Cfk73R8=Ejkb08WKXfA@mail.gmail.com>
	<CAOQ4uxiALH82=9Q4y1DNO1_-LmKy4WPpevypKndcFw-ATtNkRg@mail.gmail.com>
Date: Mon, 23 Apr 2018 21:05:01 +0200
Message-ID: <CAJfpegvcPc-NR7sp3Smcp4wT442YF_8OGvspcPnnYAyjytO0AQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix failing overlay nonsamefs fstests
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 23, 2018 at 5:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Apr 23, 2018 at 8:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Apr 23, 2018 at 4:50 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Mon, Apr 23, 2018 at 6:37 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Wed, Apr 18, 2018 at 4:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>> On Wed, Apr 18, 2018 at 5:23 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>>> On Wed, Apr 18, 2018 at 4:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>>>
>>>>>>> FYI, Miklos has a patch set in review to fix the last of the
>>>>>>> non-standard behavior tracking test that is still failing (overlay/016).
>>>>>>> After that patch set is merged, all overlay tests will be expected to
>>>>>>> pass on master - new era ;-)
>>>>>>
>>>>>> Oh, we can write new tests that don't pass ;)
>>>>
>>>> Another one:
>>>>
>>>> fstat() returns incorrect st_ctime after unlink of a lower file/directory.
>>>>
>>>> Alternative fixes:
>>>>
>>>> 1) take some attributes from whiteout
>>>>
>>>> 2) metacopy up to tmpfile
>
> I have patches to copy up to an "orphan index":
> https://github.com/amir73il/linux/commits/ovl-rocopyup
>
> combine that with metacopy and you have a ready and
> inexpensive place holder for st_ctime of unlinked file.

There are more bugs related to this.  For example the following
sequence will give a strange EEXIST error:

fd = open(path, O_RDONLY);
unlink(path);
fchmod(fd, 0400);

The reason is, fchmod will try to copy up the lower file, but finds a
whiteout on the upper layer, so the copy-up fails.

Actually, after unlink (last unlink, to be precise) we don't need a
physical file, any metadata changes can just go into the overlay inode
(ctime, atime, mode, uid, gid).  We just need to add a flag indicating
that the overlay inode is the authoritative source of metadata and
make sure any metadata changes go to the overlay inode.

And there's fsetxattr and fremovexattr.  Hmm.  We can also store
xattrs in memory, but that is becoming a bit complicated...  Oh well,
we can just postpone the tmpfile copyup until this happens.

Thanks,
Miklos
