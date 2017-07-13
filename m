From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] check_layer: Add tests for constant st_dev
Date: Thu, 13 Jul 2017 18:10:27 +0300
Message-ID: <CAOQ4uxj7_Q337Wi3gUXWQ0nT1ZiHWfeT_NGYS3TW73LcvRa_9A@mail.gmail.com>
References: <20170704170028.4278-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxjuKCGGK1shB1YO3Ony5Gqcv_mm7kidoeO8mgvnTqi7kw@mail.gmail.com>
 <CAOQ4uxicgyZRKxBVv+KTU8jQ0g7kSS7TWcjpNj8v5Za_gsP9iA@mail.gmail.com>
 <10642288.FqVSjOuREu@localhost.localdomain> <CAOQ4uxi16ZT-=ghVsXT0iCcGtKSXeMSPYZLMv+5X6+szMxJf8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:34897 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdGMPK3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2017 11:10:29 -0400
Received: by mail-yb0-f194.google.com with SMTP id p203so2794748yba.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 08:10:28 -0700 (PDT)
In-Reply-To: <CAOQ4uxi16ZT-=ghVsXT0iCcGtKSXeMSPYZLMv+5X6+szMxJf8Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Jul 13, 2017 at 5:59 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Jul 13, 2017 at 5:17 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
>> On Saturday, July 8, 2017 1:42:41 PM IST Amir Goldstein wrote:
>>> OK, my pseudo patch was mostly correct, but full of brainoes,
>>> push a tested patch to
>>> https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
>>>
>>> Please review and verify.
>>>
>>
>>
>> Hi Amir,
>>
>> './run --ov' on 'next' kernel (i.e. the one containing code which returns
>> pseudo st_devs for files on lowerdir) fails as shown below,
>
> Are you sure?
> I'm pretty sure that I tested this.
> What is the HEAD commit of the branch you are testing with?
>

Yes, you are right. I must've missed this basic test.
Will push a fix.

Thanks for testing this!
