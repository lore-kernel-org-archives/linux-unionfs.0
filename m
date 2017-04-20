From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 0/2] ovl: fix IS_APPEND() checks
Date: Thu, 20 Apr 2017 16:38:35 +0200
Message-ID: <CAJfpegsGgrsbUFtrPkW5ufRMWCAffRVV4hDJyEDM2dPzxz3efw@mail.gmail.com>
References: <1491652147-19794-1-git-send-email-amir73il@gmail.com> <CAOQ4uxhe2Ec9fB2x4ovx5CCxXQKw+CV7a+zdjk6JBo4Vj1aWOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33332 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965945AbdDTOih (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 10:38:37 -0400
Received: by mail-oi0-f43.google.com with SMTP id y11so21432061oie.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2017 07:38:37 -0700 (PDT)
In-Reply-To: <CAOQ4uxhe2Ec9fB2x4ovx5CCxXQKw+CV7a+zdjk6JBo4Vj1aWOw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 20, 2017 at 2:19 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Apr 8, 2017 at 2:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> This series fixes the append-only violations found by the new
>> xfstest overlay/030.
>>
>> I addressed your comments on v2 and removed the patch to vfs_truncate()
>> because d_real() already takes cares of IS_APPEND().

Pushed.

Thanks,
Miklos
