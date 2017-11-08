From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/1] ovl: Put upperdentry if ovl_check_origin() fails
Date: Wed, 8 Nov 2017 17:11:07 +0200
Message-ID: <CAOQ4uxjLkmuZ=cmifNPqHAWbhrR2E_MXfw89Wkis2Rn2n0b38w@mail.gmail.com>
References: <20171101193722.10228-1-vgoyal@redhat.com> <20171108142757.GA21988@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:55864 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdKHPLI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 10:11:08 -0500
In-Reply-To: <20171108142757.GA21988@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "stable [v4.9]" <stable@vger.kernel.org>

On Wed, Nov 8, 2017 at 4:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 01, 2017 at 03:37:22PM -0400, Vivek Goyal wrote:
>> If ovl_check_origin() fails, we should put upperdentry. We have a reference
>> on it by now. So goto out_put_upper instead of out.
>>
>> Fixes: a9d019573e88 ("ovl: lookup non-dir copy-up-origin by file handle")
>> Cc: <stable@vger.kernel.org> #4.12
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Hi Amir, Miklos,
>
> Does this patch look fine? I think its a simple bug fix and should go
> in 4.15.
>


Agreed.

Amir.
