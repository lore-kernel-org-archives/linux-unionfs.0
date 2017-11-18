From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/3] overlay/017: Remove constant st_ino/d_ino test for hardlinks
Date: Sat, 18 Nov 2017 22:34:26 +0200
Message-ID: <CAOQ4uxj--m7AsNEnUmGm-HHN6W8WmgxnpdvPsJptitUF__D1nQ@mail.gmail.com>
References: <20171118055804.17611-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34710 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423473AbdKRUe2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Nov 2017 15:34:28 -0500
In-Reply-To: <20171118055804.17611-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Sat, Nov 18, 2017 at 7:58 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> Constant st_ino/d_ino for hardlinks requires "index" config
> feature/mount option to be enabled. overlay/018 already tests constant
> st_ino feature for hardlinks. A future commit will add constant d_ino
> test to overlay/018 test.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks good and tested.

Thanks,
Amir.
