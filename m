From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: handle ENOENT on index lookup
Date: Fri, 20 Oct 2017 17:21:32 +0300
Message-ID: <CAOQ4uxgvokfgNiUCFoHtENA5-20DMB3uBN2AmfeHw5ujoQtzjg@mail.gmail.com>
References: <1508497270-27971-1-git-send-email-amir73il@gmail.com> <CAJfpegusagcsC8EM46fR9E6B0OOCsqhq==zisPioLxX91XUKbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJfpegusagcsC8EM46fR9E6B0OOCsqhq==zisPioLxX91XUKbg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "# v4 . 13" <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 20, 2017 at 4:23 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Oct 20, 2017 at 1:01 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
>> Cc: <stable@vger.kernel.org> # v4.13
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/namei.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> Miklos,
>>
>> This is a complimentary/fixup patch to the patch currently at the tip of
>> overlayfs-next. I did not run into ENOENT in my tests, but it seems that
>> all other places in overlayfs that call lookup_one_len_unlocked() check
>> the ENOENT return value and treat it the same as negative dentry.
>>
>> I suppose this could be expected from some file systems?
>
> I haven't done the research, but I suppose it's possible.  Nobody is
> forcing filesystems to cache negative dentries, although not doing so
> might be stupid.
>
> However, the patch seems to be wrong, since it does not treat -ENOENT
> quite the same way as a negative index (no warning for hard links).
>
> Btw you can use "--suppress-cc=bodycc" to not spam stable@vger with
> review patches.
>

OK, but Greg didn't seem annoyed by getting CC'ed - on the contrary..
Anyway, sent fixed v2 and CC'ed stable, since there was already a
discussion on v1

Amir.
