From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/4] ovl: honor flag MS_SILENT at mount
Date: Mon, 7 Mar 2016 10:50:13 +0100
Message-ID: <CAJfpegv3ag-dtG5cUi8tUdty0Nb7-aiV3LATX2e5E4VGTB4-bA@mail.gmail.com>
References: <20150629171856.15730.58271.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20150629171856.15730.58271.stgit@buzz>
Sender: owner-linux-security-module@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 29, 2015 at 7:18 PM, Konstantin Khlebnikov
<khlebnikov@yandex-team.ru> wrote:
> This patch hides error about missing lowerdir if MS_SILENT is set.
>
> We use mount(NULL, "/", "overlay", MS_SILENT, NULL) for testing support of
> overlayfs: syscall returns -ENODEV if it's not supported. Otherwise kernel
> automatically loads module and returns -EINVAL because lowerdir is missing.

Queued.

Thanks,
Miklos
