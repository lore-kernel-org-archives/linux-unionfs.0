From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Wed, 3 May 2017 17:43:44 +0200
Message-ID: <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, May 1, 2017 at 3:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This is v4 series of redirect by file handle and constant inode numbers.
> this series fixes constant inode numbers for stat(2) for overlayfs
> configuration of all layers on the same fs.

Great work.

I did some mutilation (aka. simplification) and pushed the result to
overlayfs-constino.v5

No time to check if it works or not, so probably not...  Will do
tomorrow, but if you have time, please feel free to test and review my
changes.

Thanks,
Miklos
