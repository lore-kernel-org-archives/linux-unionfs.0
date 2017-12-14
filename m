From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Thu, 14 Dec 2017 17:43:00 +0200
Message-ID: <CAOQ4uxhGpjn2U2Do-x_Rbb48puXRg=GuUn2vh8q+tF2diTb=_w@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com> <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
 <CAOQ4uxh-4kKPLHDXHJux2_tM35frxxNWmPEZcDu2EQ2n+yYkKA@mail.gmail.com> <20171214152128.GA5245@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171214152128.GA5245@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 14, 2017 at 5:21 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Dec 14, 2017 at 04:33:21PM +0200, Amir Goldstein wrote:
...
>> Other fsck do not have this problem.
>> They only need blockdev as input.
>> Which leads me to an idea I have been wondering about for the overlayfs
>> utilities - a specification file, e.g.:
>>
>> # create dirs and write their path to a spec file:
>> mkfs.overlay -ometacopy=on,lowerdir=... myovl.spec
>> # mount overlay using mount.overlay helper:
>> mount -t overlay myovl.spec /ovl
>> # fsck with just one configuration that is consistent with mkfs and mount:
>> fsck.overlay -n myovl.spec
>>
>> The specification file can also determine the backward incompatible
>> features of the overlay, for example, if user sets -metacopy=on during mkfs
>> mount.overlay helper will refuse to mount with kernel that does not
>> support metacopy. The reason we CAN do that with spec file is because spec
>> file determines that overlay was born with metacopy feature enabled.
>> It is not the same an overlay that was once mounted with metacopy=on and
>> then we don't allow it to mount with an old kernel.
>
> So why not store this information in an xattr on upper/ (instead of spec
> file) and then overlay specific helpers could parse it do same thing. I

Maybe.

> mean otherwise user space has to worry about storing and finding out
> right foo.ovl.spec file for any mount/unmount or other operations. From
> a user's perspective, I would be glad if I don't have to worry about
> managing another spec file per overlay mount.
>

That's one way of looking at it, another way to look at it would be now
user  doesn't need to worry 3 directories but just one file. Anyway the
spec file is meant to be an abstraction layer, not a replacement for
using existing mount options.

> This will only work if kernel is old but tools are still new. Not sure
> how many a times people run with this configuraiotion.
>

The major benefit of starting fresh with user tools and spec file is that we
can start by checking features compatibility from day 1.
You can think of a spec file as a declaration from admin that this overlay
is never going to be mounted on a kernel that doesn't support the spec
file required features.
It's fine if the "file" end up being stored in "features" or "spec" xattr on
upper dir. That is an implementation detail and we can actually make
this a user choice and user tools can both accept a spec file as input
or look for the xattr in upper dir.

Amir.
