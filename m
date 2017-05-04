From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Thu, 4 May 2017 17:14:04 +0300
Message-ID: <CAOQ4uxiYF3QxB2ksQRJDqSrxJ3Lm8MfEe8AF+mp0v7dBrSopLA@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
 <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com>
 <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com>
 <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
 <CAJfpeguVxbEQLqnz6t1sjbG5J5hWpqgqOw7qdtEZGSxd7j+y4A@mail.gmail.com>
 <CAOQ4uxiwumOLyVgzoT4pR_Lv08aGreZQNN-xW4OEpYCyxBHffg@mail.gmail.com>
 <CAOQ4uxi_h8cs67GyT3XnnQD0CoZEAA-TqBiTCsjPxHGxN9ZK7A@mail.gmail.com> <CAJfpegsDnUuPped_LJY_QfS1zqqoQ5=dW5H5yjU55mxkAawHCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsDnUuPped_LJY_QfS1zqqoQ5=dW5H5yjU55mxkAawHCQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, May 4, 2017 at 3:10 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 4, 2017 at 1:59 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> If you do like the idea, let me know if you want me to send a patch on
>> top of v5.
>>
>> Do you plan to push v5 (+ "else if" bugfix) to overlayfs-next?
>>
>> If we go for my solution to endianess, we can add that patch
>> as a fix patch (same goes for null uuid).
>
> I don't think doing the checks once per mount gets us much.  Bytes are
> cheap, checks are cheap, why add complexity?
>

I should ask myslef that question more often...

> Pushed .v6 with these fixes.  Takes care of future fixes to file
> handle byte order by allowing CPU independent byte order as well.
>

One minor review comment.

I used uuid_le_cmp(*uuid, NULL_UUID_LE) arbitrarily in my original patch,
but if we want to stick to semantic sb->s_uuid is probably more accurately
described as uuid_be, because filesystems most likely copy it in raw format
from disk.

This is purely semantic of course, but if you think that matters, may as well
replace uuid_le with uuid_be.

> I'd like to push to overlayfs-next if it appears to work and passes tests.
>

Reviewed and passed all tests.

Cheers,
Amir.
