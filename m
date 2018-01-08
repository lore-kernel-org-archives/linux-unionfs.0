From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v9 00/15] overlayfs: Delayed copy up of data
Date: Mon, 8 Jan 2018 16:42:59 +0200
Message-ID: <CAOQ4uxjM4fQstyWkZcCWA0BO40sxuTd5wNESeL_B21SNp4zdgg@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <CAOQ4uxiKAXXNOkY2gvWWkTTuw7TRu9z33az8uVf0Z47uH2LdyA@mail.gmail.com>
 <20180108141335.GB9910@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:43591 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933590AbeAHOnA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 09:43:00 -0500
Received: by mail-yw0-f177.google.com with SMTP id n25so4352470ywh.10
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jan 2018 06:43:00 -0800 (PST)
In-Reply-To: <20180108141335.GB9910@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Jan 8, 2018 at 4:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Jan 06, 2018 at 09:38:07AM +0200, Amir Goldstein wrote:
>> On Wed, Nov 29, 2017 at 5:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Hi,
>> >
>> > Please find attached V9 of the patches. Minor changes to take care of
>> > Amir's comments. I have also dropped RFC tag. If there are no concerns,
>> > then I would like these patches to be included.
>> >
>>
>> Sorry Vivek, just realized some issues:
>>
>> 1. Considering Miklos' commit
>>     438c84c2f0c7 ovl: don't follow redirects if redirect_dir=off
>>     It is probably not a good idea to allow lookup of metacopy unless
>>     metacopy=on. Is that already the behavior in V9?
>
> Hi Amir,
>
> Hmm.., no, that's not the behavior in V9. Remember, we wanted to follow
> metacopy origin even if metacopy=off. That way a user can mount a
> overlayfs with metacopy=off (which was previously mounted as metacopy=on)
> and not be broken.
>

User can also mount with redirect_dir=nofollow after previously mounting with
redirect_dir=on. It's the exact same thing.

> If we follow metacopy only if metacopy=on, then we really need some
> mechanism which can atleast warn user that this overlay mount was
> mounted with metacopy=on in the past and expect some unexpected results
> if mounted with metacopy=off.
>
> Has there been any agreement on what mechanism to use to remember what
> features have been turned on existing overlay mount.
>

There is no agreement, but there is code in upstream that "allows" the user
to make the same with redirect_dir. The consequences of this configuration is
-EPERM on lookup.
You actually have to allow this configuration for security reasons, the only
question is whether metacopy will have 3 modes (off/follow/on) or just on/off
where off implies nofollow.

Amir.
