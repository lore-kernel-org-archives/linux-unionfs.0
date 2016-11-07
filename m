From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 7 Nov 2016 09:07:53 +0100
Message-ID: <CAJfpegvzsjWBL5nu7SQt2kp7efjGMpb9L2JMxzXPXUTdDnft0Q@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com> <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Raphael Hertzog <hertzog@debian.org>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Nov 6, 2016 at 8:14 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> On Wed, Oct 26, 2016 at 2:12 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Oct 25, 2016 at 1:57 PM, Raphael Hertzog <hertzog@debian.org> wrote:
>>
>>> Do you plan to make it the default in the future when it has been
>>> available for a while?
>>>
>>> Barring any regression introduced by your patch, it seems that the feature
>>> is best available by default since it allows legitimate operations to
>>> succeed that are otherwise refused. I understand that it makes it
>>> impossible to mount the overlay filesystem with an older kernel but is
>>> that problem more widespread than the one we're fixing here?  On my side,
>>> overlayfs is only used in scenarios where the kernel is always the same
>>> (or newer compared to what created the initial filesystem).
>>
>> I think it would be safe to make it the default if upperdir is empty.
>> Nonempty implies that it was created with old kernel (or it was
>> crafted by hand).   But there should be a way to explicitly turn it
>> off;  either because of the need for backward compatibility or because
>> the old format is simply easier to work with for humans.
>>
>> How about:
>>
>> - If upper is nonempty, then leave redirect feature alone except when
>> mount option "-oredirect=on" is used to force enabling it.
>> - If upper is empty, then enable redirect feature except when mount
>> option "-oredirect=off" is used to force disabling it.
>
> I don't like this empty-nonempty upper logic.
>
> I think this feature should be off by default and be enabled
> explicitly in mount option.
> Available features could be listed in sysfs /sys/fs/overlay/..., like ext4 does.
>
> Overlayfs mounting anyway is complicated operation.
> User must know a lot about it and provide persistent state for each mount:
> list layers in correct order, work and uppder directory on the same disk, etc.
> Enabled features is a part of this state.
>
> Probably this could be solved in userspace tool "mount.overlay" - it could load
> features and layers from config file or xattr and set required mount
> options automatically.

It seems there are some conflicting opinions here.  I have mine too,
but I'll let this simmer and concentrate on actual features for now.

Thanks,
Miklos
