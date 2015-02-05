From: =?UTF-8?B?546L5pet?= <xuw2015@gmail.com>
Subject: [overlay] what's the purpose for setting RENAME_EXCHANGE when dest is
 WHITEOUT dev
Date: Thu, 5 Feb 2015 18:01:59 +0800
Message-ID: <CAPBX1xLSso+PnADdy-r=M_+reHG86=C+ohVU3ddM60P2DxeV_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:46821 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbbBEKCA (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 5 Feb 2015 05:02:00 -0500
Received: by mail-lb0-f194.google.com with SMTP id p9so1142483lbv.1
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Feb 2015 02:01:59 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,
  I read the source code of overlay fs, it's amazing, but a few
confusion for the rename2 function.

  Here is the code:
799     if (overwrite) {

800         if (old_opaque) {
801             if (new->d_inode || !new_opaque) {
802                 /* Whiteout source */
803                 flags |= RENAME_WHITEOUT;
804             } else {
805                 /* Switch whiteouts */
806                 flags |= RENAME_EXCHANGE;
807             }
808         } else if (is_dir && !new->d_inode && new_opaque) {
809             flags |= RENAME_EXCHANGE;
                  ^^^^^^^^^^Is necessary to use RENAME_EXCHANGE? why
not let vfs_rename to remove the new(dest) entry?
810             cleanup_whiteout = true;
811         }
812     }

  Thanks,
  George.Wang
