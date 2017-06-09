From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Fri, 9 Jun 2017 15:14:38 +0200
Message-ID: <CAJfpegsar_=16d9xSPV=cUhBVrCfReHO0+Zw03r7jw5FD2XNyw@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
 <1496821884-5178-9-git-send-email-amir73il@gmail.com> <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
 <CAOQ4uxieGBvCFFsSaL0X776PBnNqt=uOHO8E5cbTWUrAeRJwzg@mail.gmail.com>
 <CAJfpegvbExTESQQTF0rkV7oTX2R-HxGuk=EJ6i3qLMYr56Kd4A@mail.gmail.com>
 <CAOQ4uxhHPa-Og__irD8MTCvy+vkWDibi-sw7wuekVnYx5Jh+Yg@mail.gmail.com>
 <CAJfpegtLfm2vPmzarUnf-EkVN+J=tii6J0UApOJ3sRp4UVDEUg@mail.gmail.com>
 <CAOQ4uxgRiNx6VkfLM+m50b2w5Y3c7+Gks=uhNknRmzNBDU5PDA@mail.gmail.com> <CAJfpegvARnYsEaqq+3Roypvkacf0n9R5A8A-NDL4=t3EaffJyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:33305 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbdFINOk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2017 09:14:40 -0400
Received: by mail-ot0-f173.google.com with SMTP id k4so38621030otd.0
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2017 06:14:39 -0700 (PDT)
In-Reply-To: <CAJfpegvARnYsEaqq+3Roypvkacf0n9R5A8A-NDL4=t3EaffJyQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jun 9, 2017 at 1:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jun 9, 2017 at 11:38 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> The challenge is in accounting the number of link-ups atomically with
> the link-up itself.  No ideas off-hand.

Following would work I think:

- copy up to indexdir (it now has st_nlink == 1)
- set overlay.nlinkup to "1-2"
  + the first number indicates the target number of linkups
  + the second indicates the target st_nlink on the file
- fsync the file (hopefully this writes the xattrs as well as the data)
- link the file from indexdir to upper
- set overlay.nlinkup to "1"
   + this indicates that the linkup was finished and number of linkups is 1.

There are 3 cases when we find a file with overlay.nlinkup:

- just one number: nothing to do
- two numbers and second number == st_nlink: replace with just the linkup value
- two numbers and second number != st_nlink: replace with decremented
linkup value

So the atomicity is guaranteed by st_nlink becoming in sync with the
target value.

Would need to ensure that ovl_link() is not performed in parallel with
the linkup procedure.

Thanks,
Miklos

 - power fai


overlay.nlinkup
