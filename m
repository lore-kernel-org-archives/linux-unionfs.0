From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [bug report] ovl: introduce the inodes index dir feature
Date: Tue, 11 Jul 2017 14:06:58 +0300
Message-ID: <CAOQ4uxjb0Ls3ntWuJ=yJBXqFZKtQcwTJfgPHoTB1uHoiPo8EoQ@mail.gmail.com>
References: <20170710141611.wlz2rsoul4v43bi6@mwanda> <CAOQ4uxgrbbRj2mB6gNz_DRMbcctYFb-xSk_f53UkwCfF-3pEew@mail.gmail.com>
 <20170711073721.wwaovemvvonxhja4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35217 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754175AbdGKLG7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 07:06:59 -0400
Received: by mail-yw0-f196.google.com with SMTP id z21so6889815ywz.2
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 04:06:59 -0700 (PDT)
In-Reply-To: <20170711073721.wwaovemvvonxhja4@mwanda>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Jul 11, 2017 at 10:37 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Mon, Jul 10, 2017 at 07:15:47PM +0300, Amir Goldstein wrote:
>> >   1064
>> >   1065                  if (ufs->indexdir) {
>> >                             ^^^^^^^^^^^^^
>> > We check for NULL here so the code so that's OK except what do we want to
>> > set the error code to if ovl_workdir_create() fails?  Right now it's
>> > set to a random pointer casted to int.
>>
>> I don't follow.
>> If ovl_workdir_create() fails, ufs->indexdir will be NULL and err will be 0.
>> If it succeeds err will be set here below.
>>
>
> Oh, yeah.  You're right.  My bad.
>

Hmm.. interesting, I think your static analysis was correct and there *is* an
error related to random value of err, but it was not introduced by my patch.
err in not set to a defined value before:

ufs->creator_cred = cred = prepare_creds();
if (!cred)
               goto ...

if (!config.index) err was last set at err = PTR_ERR(mnt);
in the for loop above.

I'll send out a patch.
Thanks.
