From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [experimental PATCH] ovl: get rid of d_real()
Date: Fri, 15 Sep 2017 19:11:12 +0200
Message-ID: <CAJfpegs4R+MhZjmJabS8u6qGZuHi40MikeeWkyDq7SFj5_9USg@mail.gmail.com>
References: <20170915135805.GD19278@veci.piliscsaba.szeredi.hu> <20170915140734.GY5426@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170915140734.GY5426@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 15, 2017 at 4:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 15, 2017 at 03:58:05PM +0200, Miklos Szeredi wrote:
>> And here's the prototype.  Poof, d_real() is gone.
>>
>> It definitely has got problems, but just maybe it can be made better than the
>> current mess.  It *does* solve the ro-rw inconsistency for normal reads (not
>> mmaps).
>
> ... and makes for mind-boggling amount of opening/closing the files on underlying
> filesystem.  Doing that on sodding ->read_iter() is simply wrong.

I said it is a prototype.  Caching the open files on the underlying fs
would solve that.

>  And you are
> using the wrong credentials for those opens, anyway - it should be creds of opener,
> not reader.

Actually it should be credentials of mounter, as is now done
consistently across overlayfs.

And a bunch of other issues, probably.

Thanks,
Miklos
