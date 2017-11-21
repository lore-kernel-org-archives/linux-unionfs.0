From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] overlay/038: code cleanup
Date: Tue, 21 Nov 2017 08:33:53 +0200
Message-ID: <CAOQ4uxg7HwRQ8P5ywrfq=s4NTDRavinoX3BMNyWOBQL9Pj6n-A@mail.gmail.com>
References: <20171120143410.23357-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:38803 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbdKUGdy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Nov 2017 01:33:54 -0500
In-Reply-To: <20171120143410.23357-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Nov 20, 2017 at 4:34 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit implements similar changes made to overlay/041 test i.e.
> - Remove duplicate merged dir tests
> - Remove duplicate pure upper dir inside merged dir tests
> - Sort out comments and error messages
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks good and tested.

Nit: one trailing whitespace in this patch.
Applying: overlay/038: code cleanup
.git/rebase-apply/patch:114: trailing whitespace.

warning: 1 line adds whitespace errors.


Thanks,
Amir.
