From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/1] ovl: Put upperdentry if ovl_check_origin() fails
Date: Thu, 9 Nov 2017 11:07:52 +0100
Message-ID: <CAJfpegtqD15p_iO_snwtGQZs1GkKo0eJPyDj4BCsEkqcgBLuKA@mail.gmail.com>
References: <20171101193722.10228-1-vgoyal@redhat.com> <20171108142757.GA21988@redhat.com>
 <CAOQ4uxjLkmuZ=cmifNPqHAWbhrR2E_MXfw89Wkis2Rn2n0b38w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:45206 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753798AbdKIKHy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 05:07:54 -0500
Received: by mail-wm0-f51.google.com with SMTP id y80so15820682wmd.0
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Nov 2017 02:07:53 -0800 (PST)
In-Reply-To: <CAOQ4uxjLkmuZ=cmifNPqHAWbhrR2E_MXfw89Wkis2Rn2n0b38w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, "stable [v4.9]" <stable@vger.kernel.org>

On Wed, Nov 8, 2017 at 4:11 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 8, 2017 at 4:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, Nov 01, 2017 at 03:37:22PM -0400, Vivek Goyal wrote:
>>> If ovl_check_origin() fails, we should put upperdentry. We have a reference
>>> on it by now. So goto out_put_upper instead of out.
>>>
>>> Fixes: a9d019573e88 ("ovl: lookup non-dir copy-up-origin by file handle")
>>> Cc: <stable@vger.kernel.org> #4.12
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>
>> Hi Amir, Miklos,
>>
>> Does this patch look fine? I think its a simple bug fix and should go
>> in 4.15.
>>

Thanks, applied.

Miklos
