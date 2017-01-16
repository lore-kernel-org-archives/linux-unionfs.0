From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/6] ovl: check if upperdir fs supports O_TMPFILE
Date: Mon, 16 Jan 2017 15:29:22 +0100
Message-ID: <CAJfpegtgRUV+ak4gAr1a1RgtH91FvGg2r3u6FsbT_rjXt9AWXQ@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
 <1484488652-611-3-git-send-email-amir73il@gmail.com> <CAJfpeguX-N0RXrO3oj_ebWPuMPeRcvHn68dx8pO72KdQxthTUQ@mail.gmail.com>
 <CAOQ4uxjYkohzqSnpAg45WMEGxFEFYJbi3FCrdaODz3SjBBTPZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjYkohzqSnpAg45WMEGxFEFYJbi3FCrdaODz3SjBBTPZQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 16, 2017 at 3:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> The question is whether anybody actually using it with an fs that
>> doesn't have all of the above.  Because if so, we need to keep
>> supporting them.  Perhaps we should add warnings about deprecation and
>> if nobody complains we can remove support for non-conformant fs.
>>
>
>
> But how exactly do we "support" those fs right now?
> Any attempt to use them would result in -EINVAL, because we will
> bw requesting RENAME_EXCHANGE and RENAME_WHITEOUT

Not unless whiteout/opaque objects are involved, and in fact those are
not very common, so I can imagine a limited usage that doesn't involve
those and will work fine.  But I don't think this scenario is likely,
so we should try deprecating it.

Thanks,
Miklos
