From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Fri, 21 Oct 2016 16:18:26 +0300
Message-ID: <CAOQ4uxivzKJiddwbbEYvikg=END_z0ka7jkSCa1Bo1G-VWdAKw@mail.gmail.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
 <20161020204630.GA1000@redhat.com> <CAOQ4uxifGOjL37VNMg1kX6dB3E87gcbp1HPg9YHP2aQcJBvYMA@mail.gmail.com>
 <CAJfpegvEK9=aYdtpqFyT9QQAn5_ugpucd5JLuMrAO1uv8DnQ1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvEK9=aYdtpqFyT9QQAn5_ugpucd5JLuMrAO1uv8DnQ1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 21, 2016 at 12:30 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Oct 21, 2016 at 11:13 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> I think it would be a good idea in general to stabilize the overlay ino/dev
>> throughout copy-up, same as Miklos suggested to do for directories, to
>> all files:
>> pure upper uses upper ino + overlayfs dev
>> non-pure upper uses lower ino + overlayfs dev
>
> Making st_ino, st_dev and d_ino behave consistently would be the next big step.
>
> The above scheme only works if lower and upper are on the same
> filesystem.  Otherwise there can be collisions between the lower and
> upper inode numbers.  Perhaps you meant:
>
> - pure upper uses upper ino + upper dev
> - non-pure upper uses lower ino + overlayfs dev
>
> It works for the single lower layer case, but again breaks if there
> are multiple lower layers.   And d_ino in a merged directory could
> still get us into trouble.  And find -xdev would not do what you'd
> expect with a "normal" filesystem.
>
> So there doesn't appear to be any easy solutions to this...
>

Not for the general case there isn't, but I was actually thinking of
the docker case
and there is a lot that can be done for the use case of lower and upper on the
same fs to make overlayfs more compliant.
Since it's quite a common use case, perhaps its worth the special treatment.

Amir.
