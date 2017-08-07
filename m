From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 07/10] ovl: mount overlay read-only on failure to verify
 index dir
Date: Mon, 7 Aug 2017 18:12:38 +0200
Message-ID: <CAOQ4uxiqDDPaFtw9F5+fyLkseXCw1tTYNtOjT5hwrvs=6Rkxuw@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-8-git-send-email-amir73il@gmail.com> <CAJfpegvR5qZWb6dJRMSL4N-qpbJT1rqN_1KkVZhO4G2AgJWd3g@mail.gmail.com>
 <CAOQ4uxiQ7ONfkbx=buUTaS6bCpDurHk7qB5vj6c9wOesJbS4FQ@mail.gmail.com>
 <CAJfpegsTGkUuRCuJOZh5N8Q5DL0qvFBL5NgNSVYE8XV+5yF4nw@mail.gmail.com>
 <CAOQ4uxjY-=7RdF1DLibLrHVVWp5bTgCrVORn-VJngRxmLzBz1w@mail.gmail.com>
 <CAJfpegsoy_BSp4tLph3wOE1o18jdHjEEnz1XOeTjTMRd0SLojQ@mail.gmail.com>
 <CAOQ4uxhxU2dH_qsxAJoeUyJVtOU+0YxRNNdeVaiqL1A6e3NmLw@mail.gmail.com> <CAJfpegu+HnPrt0LKCLsPaWskkNMD0dcXWXdb_Zm3hZ4ovpvTKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:37552 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751876AbdHGQMj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Aug 2017 12:12:39 -0400
Received: by mail-yw0-f195.google.com with SMTP id s143so559891ywg.4
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Aug 2017 09:12:39 -0700 (PDT)
In-Reply-To: <CAJfpegu+HnPrt0LKCLsPaWskkNMD0dcXWXdb_Zm3hZ4ovpvTKA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jul 24, 2017 at 10:33 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jul 14, 2017 at 1:17 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Jul 14, 2017 at 1:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Jul 14, 2017 at 12:35 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>> What? always warn on boot? on mount? I donno. To me the comment
>>>> about backward compat in Kconfig seems sufficient and no sysadmin
>>>> can mistakenly set index=on on mount, but as I said, don't know
>>>> enough about downstream to say much.
>>>
>>> I meant warning in Kconfig.   I see that there is a warning there, but
>>> it could be made shorter and more explicit.   No need to explain the
>>> hows and whys, just warn that enabling this option is not backward
>>> compatible.
>>
>> By all means. I assume you will clean that up.
>>
>>>
>>> And if distros enable it despite this warning, and it burns their
>>> users, that's their problem.
>>>
>>
>> Hmm... but the issue related to this commit is not backward compatibility
>> is the sense that is depicted in Kconfig warning.
>> The warning speaks of mounting new overlay with an old kernel.
>> The concern discussed in this thread is mounting an old overlay
>> with a new kernel:
>>
>> This used to work with old kernel:
>> rm -rf /u.new
>> mkdir /u.new
>> mount -t overlay d /m -oupperdir=/u.new,lowerdir=/l.old,workdlir=/w.old
>>
>> And doesn't work with new kernel with INDEX=y.
>>
>> Another big behavior change that me good to warn about in Kconfig
>> is not being able to copy layers.
>
> Right.  The fact is: INDEX=y is not compatible with INDEX=n.  Despite
> that, it might well make sense for some to enable it by default,
> because compatibility of overlay images is not always (rarely?) an
> issue in practice.
>

Miklos,

Do you plan to push any changes to Kconfig warning for v4.13?
Plan to relax mount failures with -oro,index=on or keep it as is?

Let me know if you want me to do anything in that regard.

Thanks,
Amir.
