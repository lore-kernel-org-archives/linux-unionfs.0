From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 0/3] Fix overlayfs with NFS as lowerdir
Date: Tue,  1 Mar 2016 12:12:05 -0600
Message-ID: <1456855928-29913-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org
Cc: linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-unionfs@vger.kernel.org

NFS as the lower directory is not working with overlayfs because
the dentry operations have not been set correctly. However,
NFS evaluates inode and sb from the dentry, which may not be correct
when used with overlayfs. So, we store the inode in nfs_open_context
(which is translated using d_select_inode) and use it for any
inode related operations.

-- 
Goldwyn

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
