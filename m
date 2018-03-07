Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiV-UQ557AjgeHUnUGkR=U2Xz7NXA3BiygBhVzvter8=w@mail.gmail.com>
References: <20180202152324.GA2721@redhat.com> <CAOQ4uxiV-UQ557AjgeHUnUGkR=U2Xz7NXA3BiygBhVzvter8=w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Mar 2018 09:26:46 +0200
Message-ID: <CAOQ4uxhiaXjq7dw1_gZO5WS9a_=VamGaehNZkZW4D7VngcnC=Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: redirect_dir=nofollow should not follow redirect for
 opaque lower
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 7, 2018 at 9:25 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Feb 2, 2018 at 5:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> redirect_dir=nofollow should not follow a redirect. But in a specific
>> configuration it can still follow it.  For example try this.
>>
>> $ mkdir -p lower0 lower1/foo upper work merged
>> $ touch lower1/foo/lower-file.txt
>> $ setfattr -n "trusted.overlay.opaque" -v "y" lower1/foo
>> $ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=on none merged
>> $ cd merged
>> $ mv foo foo-renamed
>> $ umount merged
>>
>> # mount again. This time with redirect_dir=nofollow
>> $ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=nofollow none merged
>> $ ls merged/foo-renamed/
>> # This lists lower-file.txt, while it should not have.
>>
>> Basically, we are doing redirect check after we check for d.stop. And
>> if this is not last lower, and we find an opaque lower, d.stop will be
>> set.
>>
>> ovl_lookup_single()
>>         if (!d->last && ovl_is_opaquedir(this)) {
>>                 d->stop = d->opaque = true;
>>                 goto out;
>>         }
>>
>> To fix this, first check redirect is allowed. And after that check if
>> d.stop has been set or not.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> This is already in overlayfs-next, which is the branch you should be
> rebasing on..
>


Sorry, that was supposed to be a reply on first patch of metacopy series
