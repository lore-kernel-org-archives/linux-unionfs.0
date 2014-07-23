From: "Klaus Kreil" <klaus.kreil@univie.ac.at>
Subject: Re: overlayfs v22 on kernel 3.15.5
Date: Wed, 23 Jul 2014 17:44:07 +0200
Message-ID: <cf1b705787cfc0edbf507128515e629f.squirrel@webmail.univie.ac.at>
References: <CAJfpeguH=BmevY+SM8HKBATS7B+htcX7_WLRiMFmypW_D-424Q@mail.gmail.com>
    <3a4b4cc25d1a8325934ba439d4777c35.squirrel@webmail.univie.ac.at>
    <CAJfpegs1_iTJJGvLddyF=-L9YreVCzbDL-Pum70FTO6W+MvozQ@mail.gmail.com>
    <CAJfpegubZyar3JxYg7OxFVa1O3xWoMqaHiRUS_eME_OCzv6QFA@mail.gmail.com>
    <207df75d465c4b3fe95b6a90f3531905.squirrel@webmail.univie.ac.at>
    <CAJfpegsc4swQ2e7LfKbzHYCoa3thvetLhydzqr1My2PJr=Myag@mail.gmail.com>
    <cea39652198f0108e2a026450bd74c7b.squirrel@webmail.univie.ac.at>
    <CAJfpeguZssnTxfp62VQNHOMdxDB3EC9ZOef7Qx_CVcJ9AuJG3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from grace.univie.ac.at ([131.130.3.115]:41152 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbaGWPoM (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Jul 2014 11:44:12 -0400
In-Reply-To: <CAJfpeguZssnTxfp62VQNHOMdxDB3EC9ZOef7Qx_CVcJ9AuJG3g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Klaus Kreil <klaus.kreil@univie.ac.at>, linux-unionfs@vger.kernel.org

On Mi, 23.07.2014, 15:33, Miklos Szeredi wrote:
> On Wed, Jul 23, 2014 at 2:15 PM, Klaus Kreil <klaus.kreil@univie.ac.at>
> wrote:
>> I see what you mean and I have to admit, that slipped my eye.
>>
>> This however triggers an additional question: Would this now require me
>> to
>> create an new "virtual" root directory (in your case named "upper") on
>> my
>> upperdir filesystem and move everything that was in the real root of the
>> existing upperdir filesystem to the new virtual root directory?
>
> Yes.  And in adition you need to run the following script (upperdir
> given as a single argument) to convert whiteouts from the old format
> to the new:
>
> --- overlayfs-fixup.sh ---
> #! /bin/bash
>
> upper=$1
> tmpdir=`mktemp -d`
> tmp=$tmpdir/wh
> find "$upper" -type l -print0 | while IFS= read -r -d $'\0' name; do
>         iswh=`getfattr -h -ntrusted.overlay.whiteout --only-values
> "$name" 2> /dev/null`
>         if test "$iswh" = y; then
>                 echo "changing whiteout <$name> from symlink to chardev"
>                 mknod -m0 $tmp c 0 0
>                 mv -f $tmp "$name"
>         fi
> done
> rmdir $tmpdir
> --- cut here ---
>
I had already seen the need to deal with whiteouts somewhere, but that
wasn't an issue for me because currently there are no whiteouts in my
upperdir. It only contains changed files.
After having given the new requirements some thought I, however, consider
no longer being able to use the root of my upperdir filesystem is
something I do not really like. What's the reason that this has changed
between v21 and v22 and what are the advantages? Currently I only see a
few drawbacks, but I might not see the full picture ...
In my view the old approach was much clearer for overlaying one filesystem
on top of another r/o filesystem as the old approach guaranteed that a
path to any file on each filesystem was identical resulting in offline
maintenance scripts being applicable to both the lower- and the upperdir
without change.
And in my view that was (one of) the real beatuies of overlayfs ...
>> In other words now - and contrary to the old behaviour - overlaying one
>> root directory of a filesystem onto another root directory of another
>> filesystem is no longer possible.
>
> Not at this time.
Are there any plans to revert back to the old behaviour of being able to
use the real root of the upperdir filesystem during the mount in order to
again achieve what I have described above?
>
>> If that's the case, I guess lost+found should nevertheless stay in the
>> real root directory of the upperdir?
>
> Yes.
Thanks. That was sort of expected ...
>
>>
>> Furthermore that would als mean that the workdir is never visible from
>> within the combined tree and therefore I could go away with the .work
>> and
>> rename the workdir to work.
>
> Yes.
>
Thanks again

Klaus

