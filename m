From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Fri, 21 Oct 2016 12:13:57 +0300
Message-ID: <CAOQ4uxifGOjL37VNMg1kX6dB3E87gcbp1HPg9YHP2aQcJBvYMA@mail.gmail.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu> <20161020204630.GA1000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161020204630.GA1000@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 20, 2016 at 11:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Oct 12, 2016 at 03:33:26PM +0200, Miklos Szeredi wrote:
>> This is a proof of concept patch to fix the following.
>>
>> /ovl is in overlay mount and /ovl/foo exists on the lower layer only.
>>
>>  rofd = open("/ovl/foo", O_RDONLY);
>>  rwfd = open("/ovl/foo", O_WRONLY); /* this causes copy up */
>>  write(rwfd, "bar", 3);
>>  read(rofd, buf, 3);
>>  assert(memcmp(buf, "bar", 3) == 0);
>>
>> Similar problem exists with an MAP_SHARED mmap created from rofd.
>>
>> While this has only caused few problems (yum/dnf failure is the only one I know
>> of) and easily worked around in userspace, many see it as a proof that overlayfs
>> can never be a proper "POSIX" filesystem.
>>
>> To quell those worries, here's a simple patch that should address the above.
>>
>> The only VFS change is that f_op is initialized from f_path.dentry->d_inode
>> instead of file_inode(filp) in open.  The effect of this is that overlayfs can
>> intercept open and other file operations, while the file still effectively
>> belongs to the underlying fs.
>>
>> The patch does not give up on the nice properties of overlayfs, like sharing the
>> page cache with the underlying files.  It does cause copy up in one case where
>> previously there wasn't one and that's the O_RDONLY/MAP_SHARED case.  I haven't
>> done much research into this, but running some tests in chroot didn't trigger
>> this.
>>
>> Comments, testing are welcome.
>
> Hi Miklos,
>
> This looks like a very interesting idea. In fact once file has been copied
> up and writen to, and if I do fstat(rofd), it shows the size of copied up
> file but one can read the contents. So fixing that anomaly would be nice.
>

I think it would be a good idea in general to stabilize the overlay ino/dev
throughout copy-up, same as Miklos suggested to do for directories, to
all files:
pure upper uses upper ino + overlayfs dev
non-pure upper uses lower ino + overlayfs dev
