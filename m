From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Fri, 28 Oct 2016 14:59:32 +0200
Message-ID: <CAOssrKcjcU+44hpBNLeG8EerZU6BKs3BXe0=52G2ufvYO+G0pA@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com> <20161028125620.uusbhlcwncmicvab@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161028125620.uusbhlcwncmicvab@home.ouaza.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Raphael Hertzog <hertzog@debian.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 28, 2016 at 2:56 PM, Raphael Hertzog <hertzog@debian.org> wrote:
> Hi,
>
> On Wed, 26 Oct 2016, Miklos Szeredi wrote:
>> On Tue, Oct 25, 2016 at 1:57 PM, Raphael Hertzog <hertzog@debian.org> wrote:
>
> [ redirect feature enabled by default ]
>
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
> Looks good, but is there some stickyness of the setting? My use case is
> schroot and it always starts with an empty upperdir when I create a
> temporary/throw-away chroot but if I reboot the machine, then it's possible
> that schroot will remount the overlayfs with a non-empty upperdir
> (the temporary chroot is preserved until I explicitly end the chroot).

Yes, there is stickiness (it stores the "redirect_dir" feature in an
extended attribute on upperdir).

Thanks,
Miklos
