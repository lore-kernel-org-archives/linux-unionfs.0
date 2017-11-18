From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/3] overlay/018: Add constant d_ino test
Date: Sat, 18 Nov 2017 22:35:00 +0200
Message-ID: <CAOQ4uxjfaGMbVtHy+fSOLV8=S56ZOfExC1AQ1Zo9Qm4UrjWVoA@mail.gmail.com>
References: <20171118055804.17611-1-chandan@linux.vnet.ibm.com> <20171118055804.17611-2-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:45107 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423473AbdKRUfB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Nov 2017 15:35:01 -0500
In-Reply-To: <20171118055804.17611-2-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Sat, Nov 18, 2017 at 7:58 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> Constant d_ino for hardlinks is possible only when "index" config
> feature/mount option is enabled.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks good and tested.

Thanks,
Amir.
